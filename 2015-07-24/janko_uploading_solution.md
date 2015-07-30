*When* files are uploaded
-------------------------

a) Files are uploaded on form submit

  - Upsides:
    - Simple to implement

  - Downsides:
    - The form submit is slow
      - Upload + Processing (+ Uploading to S3)
      - What if you have to submit multiple files in the same form?

b) Files are uploaded when files are chosen

  - Upsides:
    - We're using the free time in which the user is filling other fields
    - It doesn't matter if the upload is slow, there is a progress bar, the user will happily wait
    - Because of that your can happily do all the processing after upload

  - Downsides:
    - More work on the JavaScript part
    - More work on backend for clearing cache

*How* files are uploaded
------------------------

* Indirect upload

  - Upsides:
    - You can do processing on the upload

  - Downsides:
    - Your application needs to do the upload

* Direct upload

  - Upsides:
    - Less work for your application

  - Downsides:
    - You can only upload the file, you can't do any processing

*When* files are processed
--------------------------

* Upfront

  - Upsides:
    - Fastest loading of images to the user

  - Downsides:
    - You need to regenerate all versions if you decide to change dimensions

* On-the-fly

  - Upsides:
    - You don't have to regenerate versions when you change your mind

  - Downsides:
    - Slow loading of images to the user
    - To prevent that, you need to request all versions in the background, which is weird
    - You need to prevent DoS, which now greatly reduces the on-the-fly flexibility
    - Dependent on a reverse-proxy or CDN


=====
PAPER
=====


Downsides of the "perfect uploading solution"
---------------------------------------------

* Someone has to implement it (me?) :)

* You have to have a scheduled job which periodically clears the filesystem cache

  - The cache unfortunately can't be in a tmpdir (which the OS automatically clears),
    it has to be in the public/ folder

  - The task can't just erase all cached files, because some may still be in the
    process of uploading. But it can delete files which are "old enough".
