%huffman-codes.pl 

%he_decode/3: decodifica una lista di bits e ritorna un messaggio
he_decode(Bits, HuffmanTree, Message) :-
	he_decode_2(Bits, HuffmanTree, Character, RemainingBits),
	he_decode(RemainingBits, HuffmanTree, Rest),
	append(Character, Rest, Message).
he_decode([], _, []).

he_decode_2([1|Bits], HuffmanTree, Symbol, Bits) :-
	right_tree(HuffmanTree, node((Symbol, _),nil ,nil)), !.
he_decode_2([1|Bits], HuffmanTree, Message, RemainingBits) :-
	right_tree(HuffmanTree, RightTree),
	!,
	he_decode_2(Bits, RightTree, Message, RemainingBits).
he_decode_2([0|Bits], HuffmanTree, Symbol, Bits) :-
	left_tree(HuffmanTree, node((Symbol, _),nil ,nil)), !.
he_decode_2([0|Bits], HuffmanTree, Message, RemainingBits) :-
	left_tree(HuffmanTree, LeftTree),
	!,
	he_decode_2(Bits, LeftTree, Message, RemainingBits).

%he_encode/3: codifica un messaggio in un elenco di bit
he_encode([Char|RemainingMessage], HuffmanTree, Bits) :-
	he_encode_2(Char, HuffmanTree, Code),
	he_encode(RemainingMessage, HuffmanTree, Rest),
	append(Code, Rest, Bits).
he_encode([], _, []).

he_encode_2(Char, 
    node(_, node((Symbol, Weight), LeftTree, RightTree),_), Code) :-
	member(Char, Symbol),
	!,
	he_encode_2(Char, node((Symbol, Weight), LeftTree, RightTree), Rest),
	append([0], Rest, Code).
he_encode_2(Char, 
	node(_,_, node((Symbol, Weight), LeftTree, RightTree)), Code) :-
	member(Char, Symbol),
	!,
	he_encode_2(Char, node((Symbol, Weight), LeftTree, RightTree), Rest),
	append([1], Rest, Code).
he_encode_2(Char, node(([Char], _), nil, nil), []).

%he_encode_file(Filename, HuffmanTree, Bits)/3
%legge un file e lo converte in un elenco di caratteri che verra codificato.
he_encode_file(File, HuffmanTree, Bits) :-
    open(File, read, Stream),
    read_line_to_string(Stream, String),
	string_chars(String, Msg),
	he_encode(Msg, HuffmanTree, Bits).

%he_generate_huffman_tree/3: 
%genera un albero da una lista di coppie symbol_n_weight.
he_generate_huffman_tree(SymbolsAndWeights, HuffmanTree) :- 
	initialize_tree(SymbolsAndWeights, SymbolsAndWeightsTree),
	he_generate_huffman_tree_2(SymbolsAndWeightsTree, HuffmanTree).

he_generate_huffman_tree_2(SymbolsAndWeightsTree, HuffmanTree) :-
	insert_sort(SymbolsAndWeightsTree, Ordered),	
	he_generate_tree(Ordered, HuffmanTree).


%initialize_tree/2:
%formatta l'elenco dei pesi dei simboli in un albero solo foglia.
initialize_tree([(Symbol, Weight)|SymbolsAndWeights], SymbolsAndWeightsTree) :-
	initialize_tree(SymbolsAndWeights, Temp),
	append([ node(([Symbol], Weight), nil, nil)], Temp, SymbolsAndWeightsTree).
initialize_tree([],[]).

%he_generate_tree/2: 
%Algoritmo di huffman per la generazione di alberi.
he_generate_tree([A,B|Ordered], Tree) :-
	unit(A, B, United),
	append([United], Ordered, OrderedFinal),
	he_generate_huffman_tree_2(OrderedFinal, Tree),
	!.
he_generate_tree([A|[]], A) :- !.

%unit/3:unisce due nodi.
unit( node((SymbolA, WeightA), RightA, LeftA), 
	node((SymbolB, WeightB), RightB, LeftB),
	node((SymbolAB, WeightAB), node((SymbolA, WeightA), RightA, LeftA),
	node((SymbolB, WeightB), RightB, LeftB))) :-
	append(SymbolA, SymbolB, SymbolAB),
	WeightAB is WeightA + WeightB.
	
%he_generate_symbol_bits_table/2: 
%genera una tabella di coppie composta da un simbolo e il relativo codice.
he_generate_symbol_bits_table( 
	node(([Char|Symbol], Weight),LeftTree ,RightTree),SymbolBitsTable) :-
	he_encode([Char], node(([Char|Symbol], Weight),LeftTree ,RightTree), Code),
	!,
    he_generate_symbol_bits_table( 
		node((Symbol, Weight),LeftTree ,RightTree), Rest),
	append([(Char, Code)], Rest, SymbolBitsTable).
he_generate_symbol_bits_table( node(([],_), _, _), []).


%insert_sort/2:
%implementazione dell'ordinamento per l'inserimento dei nodi.
insert_sort(List,Sorted):-insert_sort2(List,[],Sorted).
insert_sort2([],Acc,Acc).
insert_sort2([H|T],Acc,Sorted):-insert(H,Acc,NAcc),insert_sort2(T,NAcc,Sorted).


insert(X,[],[X]):- !.  
insert(X,[Y|T],[Y|NT]):-sort_rule(>, X, Y),!,insert(X,T,NT).
insert(X,[Y|T],[X,Y|T]):-!.

sort_rule(Delta, node((_,WeightA),_,_), node((_, WeightB),_,_)) :-
	compare(Delta, WeightA, WeightB).

right_tree( node(_,_,RightTree), RightTree).
left_tree( node(_,LeftTree,_), LeftTree).


%he_print_huffman_tree/1: 
%stampa a terminale un HuffmanTree e serve essenzialmente per debugging.
he_print_huffman_tree(HuffmanTree) :-
    current_prolog_flag(print_write_options, Options), !,
    write_term(HuffmanTree, Options).
he_print_huffman_tree(HuffmanTree) :-
    write_term(HuffmanTree, [ portray(true),
                       numbervars(true),
                       quoted(true)
                     ]).
