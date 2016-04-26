# qt-arsdk-examples
Example applications using the qt-arsdk plugin.

## Building

```
 $ git clone https://github.com/RadialBlue/qt-arsdk-examples.git
 $ cd qt-arsdk-examples
 $ git submodule init
 $ git submodule update
 $ cd arsdk
 $ mkdir ARSDK
 $ cd ARSDK
 $ repo init -u https://github.com/Parrot-Developers/arsdk_manifests.git
 $ repo sync
 $ cd ../..
 $ qmake && make
```
