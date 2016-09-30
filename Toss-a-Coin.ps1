<#
Flip-a-Coin.ps1
#>


[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
      HelpMessage='Would you like to play an ancient game? Please add -Roman to play "Capita aut navia?" or -Greek for a regular round of chalkismos. To challenge the all-time best chalkismos-player, an additional parameter -Phryne could be used in combination with or without the -Greek parameter. To see the the rules of a game, a parameter -Help may be added.')]
    [Alias("Wait","Pause")]
    [ValidateRange(0,10000000000)]
	[int]$Delay = "3178", # in milliseconds: without the progresbar for instance, 750 for a slower pace and 178 for a reasonable responsive UX.
    [switch]$Greek,
    [switch]$Roman,
    [switch]$Phryne,
    [Alias("Text","Definition","Rules")]
    [switch]$Help,
    [switch]$Audio
)




Begin {


    # Use Get-Random to create a random array of one object plus define some other common variables
    $delay_notify_threshold = 15000 # in milliseconds (1 minute = 60000 milliseconds)
    $random_1d2 = Get-Random -Count 1 -InputObject (1..2)
    $random_1d100 = Get-Random -Count 1 -InputObject (1..100)
    $empty_line = ""
    $help_text_coin_toss = "It is not always easy to decide what is heads and tails on a given coin. Numismatics defines the obverse and reverse of a coin rather than heads and tails. The obverse (principal side) of a coin typically features a symbol intended to be evocative of stately power, such as the head of a monarch or well-known state representative. In the case of coins that do not have royalty or state representatives on them, the side that features the name of the country is usually considered the obverse. Source: [https://www.random.org/coins/]"
    $help_text_chalkismos = "The idea is to 'catch' or 'lock' the wildly spinning coin under the tip of a straight finger. Additionally it may be agreed upon that if any part of the coin extends under the first joint after the attempt, the attempt is considerd to be disqualified. Also it may be agreed upon that the remaing four fingertips of the primary hand must be placed on the table before an attempt to catch the coin is made."
    $definition_coin_toss = "In coin flipping (or coin tossing) an outcome is pronounced by each participant before a correct answer is revealed to the question, which side of a coin is facing upwards after the said coin has been tossed in the air. An ideal coin toss includes as many rotations around the coin's centre axel as possible (while the coin is still in the air)."
    $definition_capita_aut_navia = "In coin flipping (or coin tossing) an outcome is pronounced by each participant before a correct answer is revealed to the question, which side of a coin is facing upwards after the said coin has been tossed in the air. An ideal coin toss includes as many rotations around the coin's centre axel as possible (while the coin is still in the air). Linguistically oriented participants might call the obverse 'caput', if there's a single item depicted on the coin's obverse side, and 'capita' in case two or more similar items are depicted on the coin's obverse. Historically oriented participants might call the obverse 'capita' despite what is being depicted on it. The reverse is always called 'navia'."
    $definition_chalkismos = "After a player has set a coin spinning on the table and while the coin still spins freely with reasonably good amount of spin around its center axel, the player tries to stop it with an extended straight index finger without the coin bouncing away."




    # Function used to convert numerical wait times to text
    function Get-TimeDifference {
        param ($wait_time)

        If ($wait_time.Days -ge 2) {
            $time_text = [string]$wait_time.Days + ' days ' + $wait_time.Hours + ' h ' + $wait_time.Minutes + ' min'
        } ElseIf ($wait_time.Days -gt 0) {
            $time_text = [string]$wait_time.Days + ' day ' + $wait_time.Hours + ' h ' + $wait_time.Minutes + ' min'
        } ElseIf ($wait_time.Hours -gt 0) {
            $time_text = [string]$wait_time.Hours + ' h ' + $wait_time.Minutes + ' min'
        } ElseIf ($wait_time.Minutes -gt 0) {
            $time_text = [string]$wait_time.Minutes + ' min ' + $wait_time.Seconds + ' sec'
        } ElseIf ($wait_time.Seconds -gt 0) {
            $time_text = [string]$wait_time.Seconds + ' sec'
        } Else {
            $time_text = [string]''
        } # else (if)

            If ($time_text.Contains(" 0 h")) {
                $time_text = $time_text.Replace(" 0 h","")
                } If ($time_text.Contains(" 0 min")) {
                    $time_text = $time_text.Replace(" 0 min","")
                    } If ($time_text.Contains(" 0 sec")) {
                    $time_text = $time_text.Replace(" 0 sec","")
            } # if ($time_text: first)

    $time_text

    } # function


} # begin




Process {


    If ((-not $Greek) -and (-not $Phryne) -and (-not $Roman)) {

        # Specify the coin flip rules - Regular
        $header = "Heads or Tails?"
        $coline = "---------------"
        $definition = $definition_coin_toss
        $help_text = $help_text_coin_toss

        If ($random_1d2 -eq 1) { $result = "Heads" } ElseIf ($random_1d2 -eq 2) { $result = "Tails" } Else { Write-Verbose "The coin landed on its edge." -verbose
        Write-Verbose "How thick should a coin be to have a 1/3 chance of landing on edge?" } # http://www.seas.harvard.edu/softmat/downloads/2011-10.pdf



    } ElseIf ((-not $Greek) -and (-not $Phryne) -and ($Roman)) {

        # Specify the coin flip rules - Roman
        $header = "Capita aut navia?"
        $coline = "-----------------"
        $definition = $definition_capita_aut_navia
        $help_text = $help_text_coin_toss

        If ($random_1d2 -eq 1) { $result = "Capita" } ElseIf ($random_1d2 -eq 2) { $result = "Navia" } Else { Write-Verbose "Nec capita nec navia." -verbose }


    } ElseIf (($Greek) -and (-not $Phryne) -and (-not $Roman)) {

        # Specify the coin flip rules - Greek χαλκισμός
        $header = "Chalkismos"
        $coline = "----------"
        $definition = $definition_chalkismos
        $help_text = $help_text_chalkismos

        If ($random_1d100 -ge 51) { $result = "Success" } ElseIf ($random_1d100 -ge 1) { $result = "Fail" } ElseIf ($random_1d100 -eq 0) { $result = "Disqualified" } Else { Write-Verbose "The coin did not rotate." -verbose }


    } ElseIf (($Greek) -and ($Phryne) -and (-not $Roman)) {
        $header = "Chalkismos against Phryne"
        $coline = "-------------------------"
        $definition = $definition_chalkismos
        $help_text = $help_text_chalkismos

        # Specify the coin flip rules - Greek χαλκισμός against Phryne 1
        If ($random_1d100 -ge 3) { $result = "Success" } ElseIf ($random_1d100 -ge 1) { $result = "Fail" } ElseIf ($random_1d100 -eq 0) { $result = "Disqualified" } Else { Write-Verbose "The coin did not rotate." -verbose }


    } ElseIf ((-not $Greek) -and ($Phryne) -and (-not $Roman)) {
        $header = "Chalkismos against Phryne"
        $coline = "-------------------------"
        $definition = $definition_chalkismos
        $help_text = $help_text_chalkismos

        # Specify the coin flip rules - Greek χαλκισμός against Phryne 2
        If ($random_1d100 -ge 3) { $result = "Success" } ElseIf ($random_1d100 -ge 1) { $result = "Fail" } ElseIf ($random_1d100 -eq 0) { $result = "Disqualified" } Else { Write-Verbose "The coin did not rotate." -verbose }


    } ElseIf ((-not $Greek) -and ($Phryne) -and ($Roman)) {

        # Specify the coin flip rules - Roman against Phryne
        $empty_line | Out-String
        Write-Verbose "Phryne doesn't know the 'Capita aut navia' game." -verbose
        $empty_line | Out-String
        Exit

    } ElseIf (($Greek) -and ($Roman)) {

        # Specify the coin flip rules - Greek and Roman
        $empty_line | Out-String
        Write-Verbose "Please choose, which game to play (either 'Capita aut navia?' or 'Chalkismos') by removing either the -Greek or -Roman parameter from the command." -verbose
        $empty_line | Out-String
        $duo_text = "These two games cannot effectively be played at the same time with one coin."
        Write-Output $duo_text
        $empty_line | Out-String
        Exit

    } Else {

       $continue = $true

    } # else (if)




    # Define the audio results
    If (($result -eq "Heads") -or ($result -eq "Capita") -or ($result -eq "Success")) {
        $audio_result = ([char]7, [char]7)
    } ElseIf (($result -eq "Tails") -or ($result -eq "Navia") -or ($result -eq "Fail")) {
        $audio_result = ([char]7, [char]7, [char]7, [char]7, [char]7)
    } Else {
       $continue = $true
    } # else




} # Process




End {


    # Clear the screen (number 1) and display the help if set to do so
    If (-not $Help) {

        cls
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $header | Out-String
        $coline | Out-String

    } ElseIf ($Help) {

        cls
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $empty_line | Out-String
        $header | Out-String
        $coline | Out-String

        Write-Output $definition
        $empty_line | Out-String
        Write-Output $help_text
        $empty_line | Out-String

    } Else {

       $continue = $true

    } # else (if)




        # Notify the user, if the delay is over the delay_notify_threshold
        If ($Delay -gt $delay_notify_threshold) {

                    # Calculate common variables for the delay_notify_threshold
                    $result_ready = [DateTime]::Now.AddMilliseconds($Delay)
                #   $result_ready = Get-Date ((Get-Date).AddMilliseconds($Delay))
                    $result_ready_date = $result_ready.ToShortDateString()
                    $result_ready_time = Get-Date ($result_ready) -Format HH:mm:ss
                    $result_wait_time = Get-TimeDifference((New-TimeSpan -seconds ($Delay/1000)))

            Write-Verbose "A total wait time of $result_wait_time initiated." -verbose
            $empty_line | Out-String
            "The result will be given on $result_ready_date at $result_ready_time o'clock. To set this countdown to zero (and to get the result within the next second), after selecting this PowerShell window as the active window (by for instance clicking on the window header) please press [Esc] or the letter q on the keyboard. To stop this countdown and to close this script immediately without showing any results, please use the Ctrl + C key combination after selecting this PowerShell window as the active window." | Out-String

        } Else {
            $continue = $true
        } # else (if)




    # Determine if there's a real need for the progress bar and the timer and display in console accordingly
    $wait_time_total = ([DateTime]::Now.AddMilliseconds($Delay)) - (Get-Date)
    $total_seconds = [int]$wait_time_total.TotalSeconds


    If ($total_seconds -lt 1) {

        $a_progressbar_will_be_shown = $false
        Start-Sleep -m $Delay
        $continue = $true

    } Else {

        $a_progressbar_will_be_shown = $true
        Start-Sleep -m $wait_time_total.Milliseconds

        # Set the progress bar variables
        $countdown_id       = 1 # For using more than one progress bar
        $countdown_status   = " "


        # Start the progress bar and a timer
        $timer = [System.Diagnostics.Stopwatch]::StartNew()
        Write-Progress -Id $countdown_id -Activity $header -Status $countdown_status -CurrentOperation "Time Elapsed: 00:00:00" -PercentComplete 0
        Write-Host "`rResult:                              $total_seconds              " -NoNewline


        # Update the progress bar and the timer once in a second                              # Credit: Martin Pugh: "Start-Countdown"
        ForEach ($step in (1..$total_seconds)) {

            Start-Sleep -Seconds 1
            $time_elapsed = $timer.Elapsed


            # Update the progress bar                                                         # Credit: Jeff: "Powershell show elapsed time"
            Write-Progress -Id $countdown_id -Activity $header -Status $countdown_status -CurrentOperation "$([string]::Format('Time Elapsed: {0:d2}:{1:d2}:{2:d2}', $time_elapsed.Hours, $time_elapsed.Minutes, $time_elapsed.Seconds))" -PercentComplete (($step / $total_seconds) * 100)


            # Update the timer                                                                # Credit: Jeff: "Powershell show elapsed time"
            If ($($total_seconds - $step) -gt 0) {
                Write-Host $([string]::Format("`rResult:                              $($total_seconds - $step)              ")) -NoNewline
            } Else {
                Write-Host $([string]::Format("`rResult:                                            ")) -NoNewline
            } # else


            # Specify [Esc] and [q] as the Cancel-key                                         # Credit: Jeff: "Powershell show elapsed time"
            If ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyDown,NoEcho").Character)) {
                Write-Host " ...Stopping the Count Down and the Timer...";
                Break;
            } ElseIf ($Host.UI.RawUI.KeyAvailable -and ([char]27 -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
                Write-Host " ...Stopping the Count Down and the Timer...";
                Break;
            } Else {
                $continue = $true
            } # else

        } # foreach


        # Close the progress bar
        Write-Progress -Id 1 -Activity $header -Status $countdown_status -PercentComplete 100 -Completed
        $empty_line | Out-String


    } # else (progress bar)




    # Clear the screen (number 2) and display the results
    $print = "Result:                              $result"


        If (-not $Help) {

            cls
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $header | Out-String
            $coline | Out-String


                If ($Delay -gt $delay_notify_threshold) {
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                } Else {
                    $continue = $true
                } # else (if)


            Write-Output $print

                If ($Audio) {
                    Write-Host $audio_result | Out-Null
                } Else {
                    $continue = $true
                } # else (if)

            Return $empty_line


        } ElseIf ($Help) {

            cls
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $empty_line | Out-String
            $header | Out-String
            $coline | Out-String

            Write-Output $definition
            $empty_line | Out-String
            Write-Output $help_text
            $empty_line | Out-String


                If ($Delay -gt $delay_notify_threshold) {
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                    $empty_line | Out-String
                } Else {
                    $continue = $true
                } # else (if)

            Write-Output $print

                If ($Audio) {
                    Write-Host $audio_result | Out-Null
                } Else {
                    $continue = $true
                } # else (if)

            Return $empty_line


        } Else {

            $continue = $true

        } # else (if)


} # End




# [End of Line]


<#

  _    _ _     _
 | |  | (_)   | |
 | |__| |_ ___| |_ ___  _ __ _   _
 |  __  | / __| __/ _ \| '__| | | |
 | |  | | \__ \ || (_) | |  | |_| |
 |_|  |_|_|___/\__\___/|_|   \__, |
                              __/ |
                             |___/




 __   __      __
 \ \ / /      \ \
  \ v / __  __ \ \   _  ___  ____ _   _  ___   ____
   > < /  \/ /  > \ | |/ / |/  ._) | | |/ _ \ / ___)
  / ^ ( ()  <  / ^ \|   <| ( () )| |_| | (_) ( (__
 /_/ \_\__/\_\/_/ \_\_|\_\\_)__/ | ._,_|\___/ \__ \
                                 | |            _) )
                                 |_|           (__/

Write-Verbose "Χαλκισμός (chalkismos)" -verbose

"In the game called chalkismos the player had to spin a coin on the table and
then stop it with an extended index finger without the coin falling over. The
date of invention is not known but Julius Pollux reports that the greatest master
of the game was Φρύνη (a.k.a. Μνησαρέτη a.k.a. Phryne, born c. 371 BC), the famous
courtesan (ἑταίρα) in the second half of 4th c. BC. [1]


                'Καὶ μὴν καὶ ἄλλαι παιδιαὶ αἵδε πaρεoικυῖαι τῷ σχήματι τῆς λέξεως,
                χαλκισμὸς, ἱμαντελιγμὸς, ἐφεδρισμὸς, ἐποστρακισμὸς, ἀσκωλιασμός.
                Ό μὲν χαλκισμὸς, ὀρθὸν νόμισμα ἔδει συντόνως περιστρέψαντας
                ἐπιστρεφόμενον ἐπιστῆσαι τῷ δακτύλω. ᾧ τρόπῳ μάλιστα τῆς παιδιᾶς
                ὑπερήδεσθαί φασι Φρύνην τἠν ἑταίραν.'


                Ἰούλιος Πολυδεύκης (2nd century AD)
                a.k.a. Julius Pollux:   'Ὀνομαστικόν' (Onomasticon): Vol. IX, 118.
                                        [a Greek thesaurus of terms] [2]



___________________________

[1] Németh 2013, 55—56; Rowan 2009, 7; Melville-Jones 1993, no. 657;
    http://www.perseus.tufts.edu/hopper/morph?l=xalkismos&la=greek#lexicon

[2] https://archive.org/details/onomasticon01polluoft
    https://archive.org/stream/onomasticon01polluoft/onomasticon01polluoft_djvu.txt
    https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft.pdf
    https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft_bw.pdf
    https://openlibrary.org/works/OL10686184W/Onomasticon"







   _____            _ _                      _                       _      ___
  / ____|          (_) |                    | |                     (_)    |__ \
 | |     __ _ _ __  _| |_ __ _    __ _ _   _| |_   _ __   __ ___   ___  __ _  ) |
 | |    / _` | '_ \| | __/ _` |  / _` | | | | __| | '_ \ / _` \ \ / / |/ _` |/ /
 | |___| (_| | |_) | | || (_| | | (_| | |_| | |_  | | | | (_| |\ V /| | (_| |_|
  \_____\__,_| .__/|_|\__\__,_|  \__,_|\__,_|\__| |_| |_|\__,_| \_/ |_|\__,_(_)
             | |
             |_|

Write-Verbose "Capita aut navia?" -verbose

"The capita aut navia (heads or a ship), the (perhaps) original ancestral name of
the game of 'heads or tails', might have derived from the early Roman Republic
coinage that had the double-faced head of Ianus a.k.a. Janus on the obverse and the
prow of a ship on the reverse. The heads of Ianus and the prora were first used in
the Roman coinage around 225 BC, which might designate the earliest date for the
invention of the game in its current form, though without any doubt children have
been flinging coins before that with varying game-play modes. [3]

A fifth century Roman author Macrobius Ambrosius Theodosius records an example of
an ancient version of the 'heads' or 'tails' game (


        caput, capitis  = 'head'
        navis, navis    = 'ship'


) in the the seventh chapter of the first book in the seven book Saturnalia series.
The name of the game had persisted throughout the centuries in spite of the fact
that the design of the Roman coinage had changed radically by Macrobius' period. [4]


                'Regionem istam, quae nunc vocatur Italia, regno Ianus optinuit, qui,
                ut Hyginus Protarchum Trallianum secutus tradit, cum Camese aeque
                indigena terram hanc ita participata potentia possidebant, ut regio
                Camesene, oppidum Ianiculum vocitaretur. Post ad Ianum solum regnum
                redactum est, qui creditur geminam faciem praetulisse, ut quae ante
                quaeque post tergum essent intueretur: quod procul dubio ad
                prudentiam regis sollertiamque referendum est, qui et praeterita
                nosset et futura prospiceret, sicut Antevorta et Postvorta,
                divinitatis scilicet aptissimae comites, apud Romanos coluntur. Hic
                igitur Ianus, cum Saturnum classe pervectum excepisset hospitio et
                ab eo edoctus peritiam ruris ferum illum et rudem ante fruges
                cognitas victum in melius redegisset, regni eum societate muneravit.
                Cum primus quoque aera signaret, servavit et in hoc Saturni
                reverentiam, ut, quoniam ille navi fuerat advectus, ex una quidem
                parte sui capitis effigies, ex altera vero navis exprimeretur, quo
                Saturni memoriam in posteros propagaret. Aes ita fuisse signatum
                hodieque intellegitur in aleae lusum, cum pueri denarios in sublime
                iactantes capita aut navia lusu teste vetustatis exclamant.'


                Macrobius Ambrosius Theodosius (ca. AD 385/390—430)
                a.k.a. Macrobius:       Macrobii Theodosii (viri) Illustrissimi Saturnaliorum Libri I
                                        a.k.a. The Saturnalia, Book 1: 7:19—22. [5]


Despite Macrobius says that Ianus (a deity considered by Romans to be the first king
of Latium on the site of the city before its foundation, who was believed to have
two faces: to see what was going on in front and behind him; who knew the past and
foresaw the future) was the first who impressed upon copper coins anything (the ship
on which Saturnus a.k.a. Saturn arrived to Janiculum after been expelled from the
heavens by Iuppiter a.k.a. Jupiter a.k.a. Jove on one side and his own two faces on
the other) the first figures may actually have been that of sheep and oxen by the
legendary sixth king of Rome, Servius Tullius (578—535 BC) who in reality might also
have been the first to have an impress made upon copper coins.[6]

Before Servius Tullius' time, according Τιμαῖος (c. 350–260 BC, a.k.a. Timaios a.k.a.
Timaeus of Taormina a.k.a. Tauromenium a.k.a. Ταυρομένιον, who wrote 'The Histories'
containing the history of Greece from its earliest days untill the first Punic war
and was according to Πολύβιος (c. 200–118 BC, a.k.a. Polybius) popularly regarded as
'the first historian of Rome'), at Rome the raw metal only was used. [7] The form of
a sheep was widely believed to be the first figure impressed upon money, and to this
fact it was said it owes its name, 'pecunia.'[8]

Silver was not impressed with a mark until the year of the City 485 (269 BC), the
year of the consulship of Q. Ogulnius Gallus and C. Fabius Pictor and five years
before the First Punic War (264—241 BC), at which time it was ordained that the
value of the...


        denarius    = ten librae of copper              : 3274,5 g      : 115.5046oz
        quinarius   = five librae of copper             : 1637,25 g     : 57.75229oz
        sestertius  = two librae and a half of copper   : 818,625 g     : 28.87615oz [9]


The weight, however, of the libra of copper was diminished during the First Punic
War, as the republic was not having the means to meet its expenditure — in
consequence of which, an ordinance was made that the 'as' [10] should in future be
struck of two ounces weight. By this contrivance a saving of nearly five-sixths
(82,7 %) was gained, and the public debt was liquidated. The impression upon these
copper coins was a two-faced Ianus on one side, and the beak of a ship of war on the
other: the triens (one third of an 'as') however, and the quadrans (one fourth of
an 'as') bore the impression of a ship. The quadrans, too, had, previously to this,
been called 'teruncius,' as being three unciae (one twelveth of an 'as') in weight. [11]

At a later period again, when Hannibal was pressing hard upon Rome, during the
dictatorship of Q. Fabius Maximus Verrucosus Cunctator (c. 280–203 BC), asses of one
ounce weight were struck, and it was ordained that the value of the...


        denarius    = sixteen asses of copper           : 453.5924g     : 16 oz
        quinarius   = eight asses of copper             : 226.7962g     : 8 oz
        sestertius  = four asses of copper              : 113.3981g     : 4 oz


by which last reduction of the weight of the as the republic made a clear gain of
one half. Still, however, so far as the pay of the soldiers is concerned, one
denarius has always been given for every ten asses. The impressions upon the coins
of silver were two-horse and four-horse chariots, and hence it is that they
received the names of 'bigati' and 'quadrigati'.[12] The 'as' kept diminshing
in its value so that during the Cicero's time the 'as' had lost nearly all
its value and the name 'as' had entered into idioms, such as


        assem nullum dare                   to not pay a penny / (lit.) to not give a dime
        ad assem omnia perdere              to lose everything to the last penny
        vilem redigi ad assem               to diminish in value and depreciate until worth only a worthless penny


and a few centuries later, as described by Macrobius, these copper coins were being
used as toys when kids on the street threw them in the air shouting 'capita' or
'navia' trying to guess the outcome before it was revealed.



___________________________

[3] Németh 2013, 56; Rowan 2009, 7.

[4] Németh 2013, 56; Rowan 2009, 7.

[5] (Macrobii Saturnalia Liber I: 7:19—22):     Macrobius Ambrosius Theodosius (ca. AD 385/390—430), 'Macrobii Theodosii (viri) Illustrissimi Saturnaliorum, Libri I' (The Saturnalia, Book 1)
                                                http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html

[6] (Macrobii Saturnalia Liber I: 7:19—24):     Macrobius Ambrosius Theodosius (ca. AD 385/390—430), 'Macrobii Theodosii (viri) Illustrissimi Saturnaliorum, Libri I' (The Saturnalia, Book 1)
                                                http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html
    (Plin. Nat. 18.3):  Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), 'Naturalis Historiae' (The Natural History) 18.3.
                        The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:18.3
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=18:chapter=3
    (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), 'Naturalis Historiae' (The Natural History) 33.13.
                        The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13

[7] Usher 2009, 488;
    http://www.bestofsicily.com/mag/art231.htm
    (Plin. Nat. 33.13): Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), 'Naturalis Historiae' (The Natural History) 33.13.
                        The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13
    (Plin. Nat. 18.3):  Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), 'Naturalis Historiae' (The Natural History) 18.3.
                        The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:18.3
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=18:chapter=3

[8] From 'pecus, pecoris': a sheep, a goat or cattle. For instance, Gaius Plinius Secundus (AD 23—79, a.k.a. Pliny the Elder), 'Naturalis Historiae' (The Natural History) 18.3.
    Plinius 'Naturalis Historiae' 18.3:         'Pecunia ipsa a pecore appellabatur.'
    (Plin. Nat. 18.3):                          https://la.wikisource.org/wiki/Naturalis_Historia/Liber_XVIII
                                                Sim.        Naturalis Historia. Pliny the Elder. Karl Friedrich Theodor Mayhoff. Lipsiae. Teubner. 1906.
                                                            http://www.perseus.tufts.edu/hopper/text?doc=Plin.+Nat.+18.3&fromdoc=Perseus%3Atext%3A1999.02.0138
    (Plin. Nat. 33.13): The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13

[9] one libra, librae                          : 327,45 g          : 11.55046oz        a unit of measurement
    (Plin. Nat. 33.13): The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13

[10] as, assis (original)                       : 327,45 g          : 11.55046oz        a coin ('as librarius') or a unit of measurement
     as, assis (after the First Punic War)      : 56,69905g         : 2 oz              a coin or a unit of measurement
     as, assis (after the Second Punic War)     : 28.34952g         : 1 oz              a coin or a unit of measurement


        One 'as' was divided, for instance:     Name        Value       Decimal
                                                ----        -----       -------
                                                deunx       = 11/12     ≈ 91,7 %
                                                dextans     = 5/6       ≈ 83,3 %
                                                dodrans     = 3/4       = 75 %
                                                bes         = 2/3       ≈ 66,7 %
                                                septunx     = 7/12      ≈ 58,3 %
                                                semis       = 1/2       = 50 %
                                                quicunx     = 5/12      ≈ 41,7 %
                                                triens      = 1/3       ≈ 33,3 %
                                                quadrans    = 1/4       = 25 %
                                                sextans     = 1/6       ≈ 16,7 %
                                                uncia       = 1/12      ≈ 8,3 %


[11] (Plin. Nat. 33.13): The Natural History. Pliny the Elder. John Bostock, M.D., F.R.S. H.T. Riley, Esq., B.A. London. Taylor and Francis, Red Lion Court, Fleet Street. 1855.
                        http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
                        http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13

[12] ibid.







  ____  _ _     _ _                             _
 |  _ \(_) |   | (_)                           | |
 | |_) |_| |__ | |_  ___   __ _ _ __ __ _ _ __ | |__  _   _
 |  _ <| | '_ \| | |/ _ \ / _` | '__/ _` | '_ \| '_ \| | | |
 | |_) | | |_) | | | (_) | (_| | | | (_| | |_) | | | | |_| |
 |____/|_|_.__/|_|_|\___/ \__, |_|  \__,_| .__/|_| |_|\__, |
                           __/ |         | |           __/ |
                          |___/          |_|          |___/

Bibliography:

Melville-Jones,John (1993): 'Testimonia Numaria: Greek and Latin texts concerning ancient Greek coinage' Vol 1: Texts and Translations (London)."

Németh, György (2013):  'Coins In Water'
                        ACTA CLASSICA UNIV. SCIENT. DEBRECEN. XLIX., pp. 55–63.
                        https://www.researchgate.net/publication/258434610_COINS_IN_WATER

Rowan, Clare (2009):    'Slipping out of circulation: the after-life of coins in the Roman World.'
                        Journal of the Numismatic Association of Australia Vol. 20, pp. 3–14.
                        http://www.numismatics.org.au/pdfjournal/Vol20/Vol%2020%20Article%201.pdf

Theory of Probability:  http://www.pas.rochester.edu/~stte/phy104-F00/notes-2.html

Usher, Stephen (2009):  'Oratio Recta and Oratio Obliqua in Polybius'
                        Greek, Roman, and Byzantine Studies 49, pp. 487—514
                        http://grbs.library.duke.edu/article/download/1301/1381





   _____
  / ____|
 | (___   ___  _   _ _ __ ___ ___
  \___ \ / _ \| | | | '__/ __/ _ \
  ____) | (_) | |_| | | | (_|  __/
 |_____/ \___/ \__,_|_|  \___\___|


https://community.spiceworks.com/scripts/show/1712-start-countdown                            # Martin Pugh: "Start-Countdown"
http://stackoverflow.com/questions/10941756/powershell-show-elapsed-time                      # Jeff: "Powershell show elapsed time"




  _    _      _
 | |  | |    | |
 | |__| | ___| |_ __
 |  __  |/ _ \ | '_ \
 | |  | |  __/ | |_) |
 |_|  |_|\___|_| .__/
               | |
               |_|
#>

<#

.SYNOPSIS
Toss a coin or play the ancient Roman game 'Capita aut navia' or the ancient Greek
game called 'Chalkismos'.

.DESCRIPTION
The regular action in the Toss-a-Coin is to toss a coin (or flip a coin, which ever
is being preferred in describing the game of 'Heads or Tails'). The result of a coin
toss is displayed in console after the user settable amount of delay (defined in
milliseconds with the parameter -Delay, which has the aliases called -Wait and
-Pause).

To play a regular round of the ancient game called 'Chalkismos', a parameter -Greek
may be used in the command. To challenge the all-time best chalkismos-player, an
additional parameter -Phryne could be used in combination with or without the -Greek
parameter.

To play the ancient Roman game 'Capita aut navia?', a parameter -Roman may be used
in the command.

To see the the rules of a game, a parameter -Help (which has the aliases of -Text
and -Definition and -Rules) may be added to each and every command. To hear the 
result in code language, an -Audio parameter may be added to the command.

.PARAMETER Greek
To play a regular round of the ancient game called 'Chalkismos', a parameter -Greek
may be used in the command. To challenge the all-time best chalkismos-player, an
additional parameter -Phryne could be used in combination with or without the -Greek
parameter.

.PARAMETER Phryne
To play a regular round of the ancient game called 'Chalkismos', a parameter -Greek
may be used in the command. To challenge the all-time best chalkismos-player, an
additional parameter -Phryne could be used in combination with or without the -Greek
parameter.

.PARAMETER Roman
To play the ancient Roman game 'Capita aut navia?', a parameter -Roman may be used
in the command.

.PARAMETER Delay
The result of a coin toss is displayed in console after the user settable amount of
delay (defined in milliseconds with the parameter -Delay, which has the aliases
called -Wait and -Pause). The value should be an integer between 0 and ten billion.
All values under 1000 (one second) are shown without a progress bar, and for 
instance, a value of 750 results in a slower pace without any progress bars and a 
value of 178 is a reasonable responsive UX without any progress bars. The default 
value is 3178, which shows the result after roughly three seconds and displays a 
progress bar to count down the time. To get the result instantly, please set the 
value of parameter -Delay to number zero (-Delay 0).

.PARAMETER Help
To see the the rules of a game, a parameter -Help (which has the aliases of -Text
and -Definition and -Rules) may be added to each and every command.

.PARAMETER Audio
If the -Audio parameter is used in the command, after the results have been displayed
a morse code character i (two beeps) or a morse code character 5 (five beeps) is 
emitted through the speakers. The default audio mode in Toss-a-Coin is "silent". To 
find out, which sound is emitted when, please see the table below.


            Morse Code Character i        Morse Code Character 5
            ----------------------        ----------------------
                  [two beeps]                   [five beeps]

                    Heads                          Tails
                    Capita                         Navia
                    Success                        Fail


.OUTPUTS
Generates an output of a selected game in console. Displays a progress bar, if 
-Delay is set over 1000 (one second). Emits a sound, if -Audio parameter is used.

.NOTES
Please note that each of the parameters can be "tab completed" before typing them
fully (by pressing the [tab] key, not including the aliases).

Please note that the two ancient games cannot effectively be played at the
same time with using only one coin due to the radically different nature of the games.

Please see the Rules Section below for definitions of each game.


    Rules


    (1) Chalkismos          "After a player has set a coin spinning on the table 
                            and while the coin still spins freely with reasonably 
                            good amount of spin around its center axel, the player
                            tries to stop it with an extended straight index finger 
                            without the coin bouncing away."  

                            "The idea is to 'catch' or 'lock' the wildly spinning 
                            coin under the tip of a straight finger. Additionally it
                            may be agreed upon that if any part of the coin extends 
                            under the first joint after the attempt, the attempt is 
                            considerd to be disqualified. Also it may be agreed upon 
                            that the remaing four fingertips of the primary hand 
                            must be placed on the table before an attempt to catch 
                            the coin is made."




    (2) Capita aut navia?   "In coin flipping (or coin tossing) an outcome is 
                            pronounced by each participant before a correct answer
                            is revealed to the question, which side of a coin is 
                            facing upwards after the said coin has been tossed in 
                            the air. An ideal coin toss includes as many rotations 
                            around the coin's centre axel as possible (while the 
                            coin is still in the air). Linguistically oriented 
                            participants might call the obverse 'caput', if there's
                            a single item depicted on the coin's obverse side, and 
                            'capita' in case two or more similar items are depicted 
                            on the coin's obverse. Historically oriented 
                            participants might call the obverse 'capita' despite 
                            what is being depicted on it. The reverse is always 
                            called 'navia'."

                            "It is not always easy to decide what is heads and tails
                            on a given coin. Numismatics defines the obverse and 
                            reverse of a coin rather than heads and tails. The 
                            obverse (principal side) of a coin typically features 
                            a symbol intended to be evocative of stately power, such
                            as the head of a monarch or well-known state 
                            representative. In the case of coins that do not have 
                            royalty or state representatives on them, the side that
                            features the name of the country is usually considered 
                            the obverse. Source: [https://www.random.org/coins/]"




    (3) Coin toss           "In coin flipping (or coin tossing) an outcome is 
                            pronounced by each participant before a correct answer
                            is revealed to the question, which side of a coin is 
                            facing upwards after the said coin has been tossed in 
                            the air. An ideal coin toss includes as many rotations 
                            around the coin's centre axel as possible (while the 
                            coin is still in the air)." 

                            "It is not always easy to decide what is heads and tails
                            on a given coin. Numismatics defines the obverse and 
                            reverse of a coin rather than heads and tails. The 
                            obverse (principal side) of a coin typically features 
                            a symbol intended to be evocative of stately power, such
                            as the head of a monarch or well-known state 
                            representative. In the case of coins that do not have 
                            royalty or state representatives on them, the side that
                            features the name of the country is usually considered 
                            the obverse. Source: [https://www.random.org/coins/]"
    

    Homepage:           https://github.com/auberginehill/toss-a-coin
                        Short URL: http://tinyurl.com/zugcp5h
    Version:            1.1

.EXAMPLE
./Toss-a-Coin

Run the script. Please notice to insert ./ or .\ before the script name.
Uses the default game mode (a coin flip) and generates the result after the
default delay time of 3178 milliseconds.

.EXAMPLE
help ./Toss-a-Coin -Full
Display the help file.

.EXAMPLE
./Toss-a-Coin -Help -Delay 10000
Run the script, use the default game mode (a coin flip) and display the rules of
coin tossing and show the result after ten seconds.

.EXAMPLE
./Toss-a-Coin -Greek -Pause 1500 -Audio
Run the script and play a regular round of the ancient game called 'Chalkismos'
and display the result after an second and a half delay. Confirm the results with
an audible beep, which will vary depending on the result. This command will work,
because -Pause is an alias of -Delay.

.EXAMPLE
./Toss-a-Coin -Greek -Text
Run the script and play a regular round of the ancient game called 'Chalkismos'
and display the rules of the ancient Greek game called 'Chalkismos'. Generates
the result after the default delay time of 3178 milliseconds. This command will
work, because -Text is an alias of -Help.

.EXAMPLE
./Toss-a-Coin -Greek -Phryne -Definition -Delay 0
Run the script and play the ancient game called 'Chalkismos' against the all-time
best chalkismos-player and also display the rules of the ancient Greek game
called 'Chalkismos' and get the results instantly without any delay. This command
will work, because -Definition is an alias of -Help.

Please note that when playing against Phryne, it's not mandatory to use the
-Greek parameter (in this case when the rules are being displayed a command
./Toss-a-Coin -Phryne -Help -Delay 0 would result in a similar outcome).

.EXAMPLE
./Toss-a-Coin -Roman -Rules -Wait 5000 -Audio
Run the script, play the ancient Roman game 'Capita aut navia?' and display the
rules of the ancient Roman game called 'Capita aut navia?' and don't display the
the result until five seconds have passed. After the result has been shown, confirm
the result by emitting a different sound for different results. This command will 
work, because -Rules is an alias of -Help and -Wait is an alias of -Delay.

.EXAMPLE
Set-ExecutionPolicy remotesigned

This command is altering the Windows PowerShell rights to enable script execution. Windows PowerShell
has to be run with elevated rights (run as an administrator) to actually be able to change the script
execution properties. The default value is "Set-ExecutionPolicy restricted".


    Parameters:

    Restricted      Does not load configuration files or run scripts. Restricted is the default
                    execution policy.

    AllSigned       Requires that all scripts and configuration files be signed by a trusted
                    publisher, including scripts that you write on the local computer.

    RemoteSigned    Requires that all scripts and configuration files downloaded from the Internet
                    be signed by a trusted publisher.

    Unrestricted    Loads all configuration files and runs all scripts. If you run an unsigned
                    script that was downloaded from the Internet, you are prompted for permission
                    before it runs.

    Bypass          Nothing is blocked and there are no warnings or prompts.

    Undefined       Removes the currently assigned execution policy from the current scope.
                    This parameter will not remove an execution policy that is set in a Group
                    Policy scope.


For more information, please type "help Set-ExecutionPolicy -Full" or visit
https://technet.microsoft.com/en-us/library/hh849812.aspx.

.EXAMPLE
New-Item -ItemType File -Path C:\Temp\Toss-a-Coin.ps1

Creates an empty ps1-file to the C:\Temp directory. The New-Item cmdlet has an inherent -NoClobber mode
built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing
file is about to happen. Overwriting a file with the New-Item cmdlet requires using the Force.
For more information, please type "help New-Item -Full".

.LINK
https://www.researchgate.net/publication/258434610_COINS_IN_WATER
http://www.numismatics.org.au/pdfjournal/Vol20/Vol%2020%20Article%201.pdf
http://www.pas.rochester.edu/~stte/phy104-F00/notes-2.html
http://grbs.library.duke.edu/article/download/1301/1381
http://www.perseus.tufts.edu/hopper/morph?l=xalkismos&la=greek#lexicon
https://archive.org/details/onomasticon01polluoft
https://archive.org/stream/onomasticon01polluoft/onomasticon01polluoft_djvu.txt
https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft.pdf
https://ia902706.us.archive.org/27/items/pollucisonomasti02polluoft/pollucisonomasti02polluoft_bw.pdf
https://openlibrary.org/works/OL10686184W/Onomasticon
http://penelope.uchicago.edu/Thayer/L/Roman/Texts/Macrobius/Saturnalia/1*.html
http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:18.3
http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=18:chapter=3
http://www.perseus.tufts.edu/hopper/text?doc=urn:cts:latinLit:phi0978.phi001.perseus-eng1:33.13
http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.02.0137:book=33:chapter=13
http://www.bestofsicily.com/mag/art231.htm
https://la.wikisource.org/wiki/Naturalis_Historia/Liber_XVIII
http://www.perseus.tufts.edu/hopper/text?doc=Plin.+Nat.+18.3&fromdoc=Perseus%3Atext%3A1999.02.0138
https://technet.microsoft.com/en-us/library/hh847743.aspx
http://stackoverflow.com/questions/10941756/powershell-show-elapsed-time
https://community.spiceworks.com/scripts/show/1712-start-countdown
http://poshcode.org/1192
https://technet.microsoft.com/en-us/library/hh847796.aspx
https://technet.microsoft.com/en-us/magazine/hh360993.aspx
https://technet.microsoft.com/en-us/library/ee692803.aspx

#>
