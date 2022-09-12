HE-GENERATE-HUFFMAN-TREE

La funzione he-generate-huffman-tree permette di costruire un albero di huffman, prende come input la lista di simboli e pesi.

Sintassi di simboli e pesi:
(list (cons 'a 8) (cons 'b 3) (cons 'c 1) (cons 'd 1) (cons 'e 1) (cons 'f 1) (cons 'g 1) (cons 'h 1))

         
Esempio:

(he-generate-huffman-tree (list (cons 'a 8) (cons 'b 3) (cons 'c 1) (cons 'd 1) (cons 'e 1) (cons 'f 1) (cons 'g 1) (cons 'h 1)))

((A G H E F C D B) 17 (A . 8) ((G H E F C D B) 9 ((G H E F) 4 ((G H) 2 (G . 1) (H . 1)) ((E F) 2 (E . 1) (F . 1))) ((C D B) 5 ((C D) 2 (C . 1) (D . 1)) (B .3))))


HE-ENCODE

La funzione encode permette la codifica di un messaggio, in output restituisce un lista di bits.
Sintassi del messaggio : (A B)

	(he-encode '(A B) ht)

	(0 1 1 1)

HE-ENCODE-FILE

La funzione legge un messaggio da un file di testo e richiama la funzione HE-ENCODE per codificare il messagio e restituire una lista di bits. 
Sintassi dei bits : (0 1 1 1)

  (he-encode-file "C:/Users/G****/Huffman-Tree-Progetto/Lisp/encodeFile.txt" ht)

   (0 1 1 1)


HE-DECODE 

La funzione decode permette la decodifica di una lista di bits, in output restituisce un messaggio.

   (he-decode '(0 1 1 1) ht)

   (A B)

HE-GENERATE-SYMBOL-TABLE-BITS

	(he-generate-symbol-bits-table ht)

	((A 0) (G 1 0 0 0) (H 1 0 0 1) (E 1 0 1 0) (F 1 0 1 1) (C 1 1 0 0) (D 1 1 0 1) (B 1 1 1))

HE-PRINT-HUFFMAN-TREE 

La funzione stampa a terminale	un	albero di Huffman e	serve essenzialmente per debugging.
 
    (he-print-huffman-tree ht)

    NIL

 
