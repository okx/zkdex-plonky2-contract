// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 17046641309474337274512403030736182585324348683895882256738235612721081972066;
    uint256 constant deltax2 = 15202349079394750531239501512782955825930027933488635615043897582419583427955;
    uint256 constant deltay1 = 7120535629258798935172439647000006713927512358953540878251190861505075833650;
    uint256 constant deltay2 = 7700902682886901759050102431999353839262113713047927671148607377964336646943;

    
    uint256 constant IC0x = 19083520776550887974590330444304313291269019902744848996597470265926877345664;
    uint256 constant IC0y = 9826859760744966953949929842261851440201011165145436091289273312744404252786;
    
    uint256 constant IC1x = 20167307738615758812356055314882966401565970082733889512131512806297574541324;
    uint256 constant IC1y = 12056974368935429066087609242868380321680148282084248469977959667249690580218;
    
    uint256 constant IC2x = 21647596093896322131713920156231217561837291443232660277967311929494885678022;
    uint256 constant IC2y = 20262550825441854994865488762879525417535382088455096930245023551048147356483;
    
    uint256 constant IC3x = 4957814235385972687984790383558120410496030999892371846884518879885040277449;
    uint256 constant IC3y = 10351976704119905603899391675835151944496962367422277766505373109161990580446;
    
    uint256 constant IC4x = 9400551369662225188014210118604875395204365038661648659039894935660684350742;
    uint256 constant IC4y = 16719282741007435764228163115378903563012594414934908554070301439854824567955;
    
    uint256 constant IC5x = 18303824141888437019816018887630157234230516982412996580796775438410879714379;
    uint256 constant IC5y = 1611139741941634430394053948551224715174912265274189910862862166688624203503;
    
    uint256 constant IC6x = 20408460927006800237598592018701629707627358203665061524758058524576985908388;
    uint256 constant IC6y = 9467399702352468575215879384415801956093920538376703461264554988761858941284;
    
    uint256 constant IC7x = 9909889234806508520921471378921666345271678787936350859543639988792364250535;
    uint256 constant IC7y = 6879121336180283682839451897942117992515640613863228538078955468408840409766;
    
    uint256 constant IC8x = 7665037272832549208537911745807708187945457786043819171499542053716180364085;
    uint256 constant IC8y = 15957025947166038041749453056643015580603669292305617742264637201824953428612;
    
    uint256 constant IC9x = 15658808951523832313523743686523194929166275187219857994325021896332512710055;
    uint256 constant IC9y = 15962125102849839332296315039748860195232802966478785410774234928365396621838;
    
    uint256 constant IC10x = 7163193531014929775222884891583178266719428017785406056837430998937087225448;
    uint256 constant IC10y = 21138007482428268994464269187574280968232574641715619659540147769409891797152;
    
    uint256 constant IC11x = 15812371515758990421712775882487459828240075028790143426946208879222984775346;
    uint256 constant IC11y = 15223529411807059361803522759277352848620523024700384948468712875128602320808;
    
    uint256 constant IC12x = 17272613130430743407990125388712701599323356786015585824053617540558159968975;
    uint256 constant IC12y = 16645726902706303349144907251799623415481217578285281373535594335720295943030;
    
    uint256 constant IC13x = 16123243264318918945305260192138310791419090794755701023938146768231713620125;
    uint256 constant IC13y = 13053788268495119079316142715047621760143649270037057175713260883765901828532;
    
    uint256 constant IC14x = 5955468203692612724933338158024499580037787212849974805078464755291605009332;
    uint256 constant IC14y = 9280514304551851414987802146844358823996014534139474683665988760847107494743;
    
    uint256 constant IC15x = 8018861148099574377027285392704213475941631678642756953977487123913924728819;
    uint256 constant IC15y = 18691350234587513112458912876125246288708749736489848004602038235644807085668;
    
    uint256 constant IC16x = 10718263281202016789373173062730335267071131957242343137930712230725899709622;
    uint256 constant IC16y = 8810176364903978964544267391558821518500817691916972980619624765604200301080;
    
    uint256 constant IC17x = 9349317037866282569106859292745246382638109373446855775856677853374221728830;
    uint256 constant IC17y = 19119792558273094591398689777628127167394468547479132620072553941362908341799;
    
    uint256 constant IC18x = 10884421458992331850168422066947943963953518610514913192995879687618843670671;
    uint256 constant IC18y = 14067784713857358792850306073458717387883147233615371375065100333531958273985;
    
    uint256 constant IC19x = 11422397420405151026146939645514482599455165466821956548151129124003993699271;
    uint256 constant IC19y = 12669617615027621511429004454541997253403324385398719672700233855674068917154;
    
    uint256 constant IC20x = 5176111169743363173345939209184515029641924058219716984211325035536852740283;
    uint256 constant IC20y = 20284386771616411733536800694798646410271809008510686405965763361167557115698;
    
    uint256 constant IC21x = 4376928518535334851322763613552223279825740584071029918702506222547714700840;
    uint256 constant IC21y = 10777063995496950804209364061181794210087110422374598094282076310426191516155;
    
    uint256 constant IC22x = 3921165813993806537093101888769799415052329808206111250303531660146097146701;
    uint256 constant IC22y = 20232987862660169091361849728552026419749838162515908370774643068251825586111;
    
    uint256 constant IC23x = 16314445121942667903560997076535631902762775134751399957974236521872807673148;
    uint256 constant IC23y = 16222332060006810673288012384295170042569553879648745125225118200579204689855;
    
    uint256 constant IC24x = 927841605892063468328764629461466340241018410016119497735175771687212277635;
    uint256 constant IC24y = 9225373132287917087782492246836172328623390797416300203705343767210869337359;
    
    uint256 constant IC25x = 10856170048055480756471330133395517999087845346031886114940084541746355764732;
    uint256 constant IC25y = 2664464217019315574053489937324287508679316406553745748370718261806472948488;
    
    uint256 constant IC26x = 18946510202861863766120581046579482623617653536862867958940933545420564850070;
    uint256 constant IC26y = 5231651876140147398337907512453906619955083392254480549557120356103939459040;
    
    uint256 constant IC27x = 20659665995316351204212350572047541585188317654962688467636250928021470692125;
    uint256 constant IC27y = 21800300647605398767007754503547859798032157706655627169606321048386607112421;
    
    uint256 constant IC28x = 5472701160922067871178355093442723616218602988908722044201278821669621634087;
    uint256 constant IC28y = 17110219157761181766848153874721329085163490924484704037758400642086040597633;
    
    uint256 constant IC29x = 13911380391780581740672230628390761851291651756824949554829261429912366211752;
    uint256 constant IC29y = 11482490486991060499829061745978048262913426874371734528061578673831531105134;
    
    uint256 constant IC30x = 14658686628334257409597226782757477483484409694941481042832074419464393684576;
    uint256 constant IC30y = 5323554620298207232954769352304168033577964751235390478617212464616882371294;
    
    uint256 constant IC31x = 3556312808469227880085092651317215405767111115493827624191266777861257649704;
    uint256 constant IC31y = 8925292730513669501810572632595937329090751713689961676886306052981173414917;
    
    uint256 constant IC32x = 20547369325911536525470888936734330977742712419754174489159952184597741322252;
    uint256 constant IC32y = 19816640326511243721471546040349436325631978023894646799051554975844966129344;
    
    uint256 constant IC33x = 19139788115028706747706804472045700873229360609335986373132530826670020583327;
    uint256 constant IC33y = 15083205571612503934930943500617988373187453189276217696301574081533830125890;
    
    uint256 constant IC34x = 19107868272459484489133821546511018536686221898953238131824997658590716629484;
    uint256 constant IC34y = 20445478739610846288665226761434827573530553778092432465997770933141068811353;
    
    uint256 constant IC35x = 17378738013896508203910909882167012509713320158314559163110248941216955237076;
    uint256 constant IC35y = 18078011917278638096368077275827666985448709185787241663396257686440034299767;
    
    uint256 constant IC36x = 18290606475020302853558063708811361082130364227673645775462823974357333082811;
    uint256 constant IC36y = 21849785515168835498070254525256576213802289466939959863163507177604767147703;
    
    uint256 constant IC37x = 7289189462787680172380383444944032196569298507418423199667420509386432655748;
    uint256 constant IC37y = 13913148072228147364675002688285509889407820971202973393375528895484778223377;
    
    uint256 constant IC38x = 3360986533294905604014879494142086610359432931799737904994823046956754787468;
    uint256 constant IC38y = 9800070365588661475262953108911637461516746276176427659244398425069787802396;
    
    uint256 constant IC39x = 2120880798853519508006241646201319961797598529007235831910364436095303018016;
    uint256 constant IC39y = 120272610491225159978669829135180337162767274756843021860919222592634892988;
    
    uint256 constant IC40x = 4375680944115236704111536940975689412757147022733241096404784616999243208982;
    uint256 constant IC40y = 13706091178103637388923866768496469197669926612048368380398427962116691339208;
    
    uint256 constant IC41x = 17114443593090358478125936279434974587064485622280815187138641844067337928017;
    uint256 constant IC41y = 9156897332612644100990705238198722235850768178685449944211790112085539428784;
    
    uint256 constant IC42x = 9303095462049924722878689992289386933600831571601723493179009410960729199081;
    uint256 constant IC42y = 9385447845052960433457536320784274508283154934861199334359321819143782827046;
    
    uint256 constant IC43x = 108884267335111117917375091751520138851571315115943897841676576420772740089;
    uint256 constant IC43y = 13373831923299806187454019548281165158746249421019350153806228692909488203018;
    
    uint256 constant IC44x = 10282176269399269441040770715769159087103868968018352127328849309873772450998;
    uint256 constant IC44y = 5491542195344495595270008047133761119914302304262032836288097570871821525681;
    
    uint256 constant IC45x = 8194464516256313890316209159724996902825209052982107830991337177152374530361;
    uint256 constant IC45y = 5265962447204840628622821375636982949565927852027842124996539205518144453231;
    
    uint256 constant IC46x = 7883174258795808471096208602464212648055787766398789747993613810981793511279;
    uint256 constant IC46y = 16319069155048467447453431773925254370477887060726972597098291104601919335598;
    
    uint256 constant IC47x = 5213983635405654308301157198741597458513708179957870112169261992196335195337;
    uint256 constant IC47y = 16735270333637807290754321917308002426018736977784284148445625332237022687944;
    
    uint256 constant IC48x = 12560974605695857495108827665194654573913106605245001615156044819744857312745;
    uint256 constant IC48y = 21231578724495531358951027310264882634845163616272790648767830841199803305361;
    
    uint256 constant IC49x = 4603481018472238789942758885545452598862025857764347640377458848305936419288;
    uint256 constant IC49y = 10886226245836893062787307531845012563307576160596958375314130036691878623491;
    
    uint256 constant IC50x = 16268296417370678451223724254889577214509813689286555738464152050937332312006;
    uint256 constant IC50y = 806340612749664439716696318751016153088944326208827946412639103769989016525;
    
    uint256 constant IC51x = 4599441905705907062525038541047035761536839248071068335217113999833393899770;
    uint256 constant IC51y = 13026505236769709065750498104928249944671998020115509222866888386979344021184;
    
    uint256 constant IC52x = 13903626151235582070058912177217063783692074360188855121932905687029519540130;
    uint256 constant IC52y = 8370857163867550037692815752229680282934561941782275607508856070421609889808;
    
    uint256 constant IC53x = 3256347921295950394229788828057810984026811363883266804848243177454940442917;
    uint256 constant IC53y = 18276771313202124803707579955402469545437597057358157276730795046031584607164;
    
    uint256 constant IC54x = 18431208086470968910769509943791181885612749150090592685033500128804221717474;
    uint256 constant IC54y = 13996388301129784784951985142628097675252047232861738348964118879334963139722;
    
    uint256 constant IC55x = 18036196069778720185637173092869985180890218737057709128090770057591674498324;
    uint256 constant IC55y = 15389509077147528912966138061522966869767707845057564088578645164515183220578;
    
    uint256 constant IC56x = 20856823655831130467425146011043243914280699784444220235354701563372850653332;
    uint256 constant IC56y = 3914908128373406120449937155244662849711124922078765462585438762031271583236;
    
    uint256 constant IC57x = 14689841773813641769967704646753543149296442671721754696772110251566841538185;
    uint256 constant IC57y = 11578782740360812199705693086061473772466875781958006467846367574849682920553;
    
    uint256 constant IC58x = 14872041222574844329650963387187822641793671201011055463788588518412748105175;
    uint256 constant IC58y = 13726082341608945355026520035584372635849333819010411543131640910410292283771;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[58] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                
                g1_mulAccC(_pVk, IC56x, IC56y, calldataload(add(pubSignals, 1760)))
                
                g1_mulAccC(_pVk, IC57x, IC57y, calldataload(add(pubSignals, 1792)))
                
                g1_mulAccC(_pVk, IC58x, IC58y, calldataload(add(pubSignals, 1824)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            
            checkField(calldataload(add(_pubSignals, 1792)))
            
            checkField(calldataload(add(_pubSignals, 1824)))
            
            checkField(calldataload(add(_pubSignals, 1856)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
