---
title: Picard rename script examples
tags: [media, music, picard, configuration]
---


### Default
```shell
$if2(%albumartist%,%artist%)/$if2(%originalyear%,%year%). $if($ne(%albumartist%,),%album%) [$if($ne(%media%,),$lower($if($eq(%media%,Digital Media),digital,%media%)),),$if($ne(%releasetype%,),%releasetype%,)]/$if($gt(%totaldiscs%,1),%discnumber%-,)$if($ne(%albumartist%,),$num(%tracknumber%,2) ,)$if(%_multiartist%,%artist% - ,)%title%
```

### Parts
```shell
# OriginalYear if available, otherwise regular year
$if2(%originalyear%,%year%)

# Media type (lowercase)
$lower($if($eq(%media%,Digital Media),digital,%media%))

# [mediatype,releasetype]
[$if($ne(%media%,),$lower($if($eq(%media%,Digital Media),digital,%media%)),),$if($ne(%releasetype%,),%releasetype%,)]

# 01-12 <multiartist opt.> - title
$if($gt(%totaldiscs%,1),%discnumber%-,)$if($ne(%albumartist%,),$num(%tracknumber%,2) ,)$if(%_multiartist%,%artist% - ,)%title%
```



### Basic

```
$set(year,$if2(%originalyear%,%year%))
$set(mediaType,$if($eq(%media%,Digital Media),digital,$if($eq(%media%,12" Vinyl),12in vinyl,%media%)))
$set(mediaInfo,$if($ne(%mediaType%,),%mediaType%,)\,$if($ne(%releasetype%,),%releasetype%,))
$set(albumFolder,%year%. $if($ne(%albumartist%,),%album%) [%mediaInfo%])
$set(isMultiDisc,$gt(%totaldiscs%,1))
$set(discName,$if(%discsubtitle%,Disc %discnumber% - %discsubtitle%,Disc %discnumber%))
$set(discFolder,$if(%isMultiDisc%,%discName%))
$set(trackNum,$if(%isMultiDisc%,%discnumber%-,)$if($ne(%albumartist%,),$num(%tracknumber%,2) ,))
$set(trackArtist,$if(%_multiartist%,%artist% - ,))
$if2(%albumartist%,%artist%)/%albumFolder%/%discFolder%/%trackNum%%trackArtist%%title%
```


### Naming with Release Type

```
$set(year,$if2(%originalyear%,%year%))
$set(mediaType,
$if($eq(%media%,Digital Media),Digital,
$if($eq(%media%,12" Vinyl),12in Vinyl,
$if($eq(%media%,7" Vinyl),7in Vinyl,
$if($eq(%media%,Enhanced CD),ECD,
$if($eq(%media%,DVD-Video),DVD,
%media%
))))))
$set(mediaType,$if($ne(%mediaType%,),$lower(%mediaType%\,)))
$set(releaseType,$title(%_primaryreleasetype%)/)
$set(country,$if(%releasecountry%, \(%releasecountry%\)))
$set(mediaInfo,%mediaType%%releasetype%)
$set(albumFolder,%year%. $if($ne(%albumartist%,),%album%)%country% [%mediaInfo%] %barcode% )
$set(isMultiDisc,$gt(%totaldiscs%,1))
$set(discName,$if(%discsubtitle%,Disc %discnumber% - %discsubtitle%,Disc %discnumber%))
$set(discFolder,$if(%isMultiDisc%,%discName%))
$set(trackNum,$if(%isMultiDisc%,%discnumber%-,)$if($ne(%albumartist%,),$num(%tracknumber%,2) ,))
$set(trackArtist,$if(%_multiartist%,%artist% - ,))

$if2(%albumartist%,%artist%)/%releaseType%/%albumFolder%/%discFolder%/%trackNum%%trackArtist%%title%
```

### Current
```
$set(year,$if2(%originalyear%,%year%))
$set(mediaType,
$if($eq(%media%,Digital Media),Digital,
$if($eq(%media%,12" Vinyl),12in Vinyl,
$if($eq(%media%,7" Vinyl),7in Vinyl,
$if($eq(%media%,Enhanced CD),ECD,
$if($eq(%media%,DVD-Video),DVD,
%media%
))))))

$set(discsubtitle,$if2(
$if($startswith(%discsubtitle%,Outtakes and Previously Unreleased Music From: Star Wars),
	Outtakes and Unreleased
),
%discsubtitle%
))

$set(_primaryreleasetype,
$if($eq(%_primaryreleasetype%,ep),EP,
$title(%_primaryreleasetype%))/
/)

$set(releaseType,$title(%_primaryreleasetype%)/)
$set(mediaType,$if(%mediaType%,$lower(%mediaType%)))

$set(catalogNumber,$if(%catalognumber%,$if($eq(%catalognumber%,[none]),,%catalognumber%)))


$set(releaseDetail,[%mediaType%\,%releasetype%] [%releasecountry%$if(%catalogNumber%,\,%catalogNumber%)])

$set(isMultiDisc,$gt(%totaldiscs%,1))

$set(discName,
$if($rsearch(%discsubtitle%,^Disc \\d),%discsubtitle%,
$if(%discsubtitle%,Disc %discnumber% - %discsubtitle%,
Disc %discnumber%
)))

$set(discFolder,$if(%isMultiDisc%,%discName%))
$set(trackNum,$if(%isMultiDisc%,%discnumber%-,)$if($ne(%albumartist%,),$num(%tracknumber%,2),))
$set(trackartist,$if(%_multiartist%,%artist%))

$set(albumFolder,%year%. %album% %releaseDetail% )
$set(albumartist,$if2(%albumartist%,%artist%))

$set(isSoundtrack,$in(%releasetype%,soundtrack))
$set(soundtrackFolder,%album%$if(%year%, \(%year%\)))

$if(%isSoundtrack%,
	Soundtracks/%soundtrackFolder%/%discFolder%/%trackNum% %artist% - %title%,
	%albumartist%/%releaseType%/%albumFolder%/%discFolder%/%trackNum% $if(%trackartist%,%trackartist% - )%title%
)
```