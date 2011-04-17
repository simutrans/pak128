<?php

    /* This file takes a set of images and merges them to one and returns them. */
    header ("Content-type: image/png");

    /* At first get a list of files to prepare correct image. */
    $target_dir = "./join/";
    $dh  = opendir($target_dir);
    while (false !== ($filename = readdir($dh)))
    {
        //store the names
        if (($filename != ".") and ($filename != "..") and (substr_count (strtolower($filename), ".png") > 0))
            $files[] = $filename;
    }
    closedir($dh);
    sort($files);

    //get unber of required rows
    $number_of_rows = floor(count($files) / 8);
    if ($number_of_rows < 1) $number_of_rows = 1;

    $images_to_proces = 8;
    if (count ($files) < 8) $images_to_proces = count ($files);

    $target_im = @imagecreatetruecolor(1152, $number_of_rows * 128)
        or die("Cannot initialize new GD image stream (create empty canvas)");

    /*Copy a part of src_im onto dst_im starting at the x,y coordinates src_x, src_y
    with a width of src_w and a height of src_h.
    The portion defined will be copied onto the x,y coordinates, dst_x and dst_y. */
    for ($b = 0; $b < $number_of_rows; $b ++)
    {
        $y = $b * 128;

        for ($a = 0; $a < $images_to_proces; $a++)
        {
            $source_image_path = $target_dir . $files[($b*8) + $a];

            /* Attempt to open */
            $source_im = @imagecreatefrompng($source_image_path);

            /* See if it failed */
            if (!$source_im)
                die ("Cannot open the image" . $source_image_path . ".");

            /*copy the image block to the target image */
            @ imagecopy ($target_im, $source_im, ($a * 128), $y, 0, 128, 128, 128)
                or die("Cannot copy the image" . $source_image_path . "to the target.");

            imagedestroy($source_im);
        }
    }

    /* Now add an empty white square */
    imagefilledrectangle ($target_im, 1024, 0, 1151, ($number_of_rows * 128) - 1, 0xFFFFFF);

    /* For sure make a flood fiill with  dummy transparency color.
       Include a small transparent rectangle for future processing.*/
    imagefill ($target_im, 0, 0, 0xFFAADD);
    imagefilledrectangle ($target_im, 0, 0, 10, 10, 0xE7FFFF);

    /*output */
    imagepng($target_im);
    imagedestroy($target_im);

?>
