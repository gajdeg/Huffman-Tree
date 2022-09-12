
Codificatore/decodificatore da un'albero di Huffman in Prolog.

he_decode (Bits, HuffmanTree, Message): true se Bits è un messaggio codificato seguendo HuffmanTree.

he_encode (Message, HuffmanTree, Bits): true se il messaggio è il Bit decodificato seguendo HuffmanTree.

he_encode_file(Filename, HuffmanTree, Bits): true se il messagio letto da un file è il Bit decodificato seguendo HuffmanTree 

he_generate_huffman_tree (SymbolsAndWeight, HuffmanTree): true se HuffmanTree è l'albero generato da SymbolsAndWeights.

he_generate_symbol_bits_table (HuffmanTree, SymbolBitsTable): true se SymbolBitsTable è una lista che accoppia caratteri da HuffmanTree con il relativo codice.

he_print_huffmanTree stampa a terminale	un albero di Huffman e	serve essenzialmente per debugging.


SINTASSI

Sintassi di simboli e pesi:
 [(a,8),(b,3),(c,1),(d,1),(e,1),(f,1),(g,1),(h,1)]

Sintassi di HuffmanTree:
 HT = node(([a,c,d,h,g,f,e,b],17),node(([a],8),nil,nil),node(([c,d,h,g,f,e,b],9),node(([c,d,h,g],4),
 node(([c,d],2),node(([c],1),nil,nil),node(([d],1),nil,nil)),node(([h,g],2),node(([h],1),nil,nil),
 node(([g],1),nil,nil))),node(([f,e,b],5),node(([f,e],2),node(([f],1),nil,nil),node(([e],1),nil,nil)),node(([b],3),nil,nil))))
 
Sintassi dei bit: [0, 1, 1, 1]

Sintassi del messaggio: [a, b]

Sintassi SymbolBitsTable: [(a,[0]),(c,[1,0,0,0]),(d,[1,0,0,1]),(h,[1,0,1,0]),(g,[1,0,1,1]),(f,[1,1,0,0]),(e,[1,1,0,1]),(b,[1,1,1])].

?- symbols_n_weights(X),
|    he_generate_huffman_tree(X, HT),
|    he_encode_file("/home/Desktop/Prolog/encodeFile.txt", HT, B).
