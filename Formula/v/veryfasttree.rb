class Veryfasttree < Formula
  desc "Efficient phylogenetic tree inference for massive taxonomic datasets"
  homepage "https:github.comcitiususcveryfasttree"
  url "https:github.comcitiususcveryfasttreearchiverefstagsv4.0.4.tar.gz"
  sha256 "27c779164f4fa0c75897a6e95b35f820a2a10e7c244b8923c575e0ea46f15f6b"
  license "GPL-3.0-only"
  head "https:github.comcitiususcveryfasttree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be966294bd7e7793920e064538c8f301d30cf36e836149151a7dc9749751699e"
    sha256 cellar: :any,                 arm64_sonoma:  "ad4a872d4517fad3f3a1ee924c42cd529cc50583d1cd01267808a64f30122c33"
    sha256 cellar: :any,                 arm64_ventura: "5feeb83511115643cddc8bd05cea9b8215606d1e39edb9eba23028c5d646a02e"
    sha256 cellar: :any,                 sonoma:        "84f8d609b53f4eccf0471604f90098e8a2e9525cc1eb8a942a0a9896f405bcf5"
    sha256 cellar: :any,                 ventura:       "b675c4443158d46942e000086a79e1b3d8262ffb9703d9dd23ae256fea2895d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93bc3678c5bc47c3f3a82b01e6a81ce7c247119fa1086cd1c5c1bafa4f979720"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "robin-map" => :build
  depends_on "xxhash" => :build
  depends_on "libomp"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DUSE_SHARED=ON", "-DUSE_NATIVE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "manVeryFastTree.1"
  end

  test do
    (testpath"test.fasta").write <<~EOS
      >N3289
      --RNRSCRRDNTNGQDLQAALAIFAAKVYVGVALQSVQVAAGIGKHPVYKHIPSKKYTGL
      IIQELYLERLMAELADGLADAAPDVLLDIRGLMLALDAPAREKPIIL-LHLAASAGDALR
      DKGQALRRELLPRLSGLGYAGLASGALTGDNATLMSARLIGLLVSATLLAL---------
      -----------------
      >N1763
      ------ISKDTTEERFLEVDKLTFAPKSYAGTLQTKILSAVSVPAGTLYKDFPTTELALL
      VTLEVYQATDTSGAQDGLAANARDILHVLVELFLALAGFAAQDPLHLLLPMAAALTSSLR
      GRLRELRRELLAKGAAKVYTGLGAADATGDGVQLGAASLAMQLLGALLPCLRLDALLGSL
      ASGLPEEKLASLAIFL-
      >N2100
      --RGRARPKQTTAESNLDATMGKFASQEYDGTMHRELGAASGVSLGTLYPDYPTWEMLIL
      VTLESYLEPVVSALYAGLATDAPDILQR-LQLFLALLGFAMNHPGALLKSLAATLESELC
      GKLKALTREVLEKLGASVFEGLPEPTLTGDEATPMSAALLMPLVQALLLCLLLQPLLAKH
      SDDLPQIILAIYGIF--
      >N774
      --RGRRRTKTIVSEKDLSATMGRFAEQPYDGSLERNAATAASAPLNTMYGEFPTQDMFLL
      MCLESYLIPTVLEADAE-ATEARDVLRRRLQLFLALLGFALNHPTQLLKMLATTLHKALR
      GKIKDLQREVFARLTASAPAGLAAQFLTGDNATLMEAVLLMPFLAALLSCLILEPLDRKF
      ADDFPAVILAIYAIF--
      >N211
      --KARGRTTIETGEKVLTGEMDRFAELQYDGSLQRDDTTGAAPPLGTLYGKLPTQDMFLL
      FALESYLDPGTPELGQGLATKAPDGLRKRLHLFLGLLSFSLDHPVHLLKSLATT-HKAVR
      GKVKDLQRDRFARLNASAPSGIAHPALTGDMATLMEAGLLMPLLAALLPILILAPLDKKY
      AHDNHNDILAIYAIFLT
      >N747
      MGKARGITTAYAYSQVLIGRLGAHAALPYNGSLERKDVAALDAPTNKLYGQFPDGDSWLL
      GALEAYIHTCPPELPQSLATQAPETIFTRLQPYLGLADFGLAHPGQLLKIEATKLQRAVR
      GKFKELQKDAPAQLTANGITVVGQPNLTGDLGTLSEAVVLLQLVPSLLAAIIFKPIDKKY
      GESAPVGILLPFSVW--
      >N952
      MGRGRARTTVEAGEKVLLGTMIRFAELPHDGSLQRNDSTALAAPLNTLYAKFPTQDMFLL
      FALESYLHPSSPELGMGLATPAPDILRKRLALFLGLLSFSLEHPIQLLKSLATT-HKAVR
      GPFKDLQKDVPAHLTATAPSGIAHPALTGDMATLMEAVLLMPLLAALLPVLVLKPLDKKF
      ADDSPGDILAVYAIF--
      >N3964
      ------RTTVEDNDKVLNATMDRFADLPYDGSLQRDDTTAQTAPLGTLYGKFPTADMFLL
      NALESYLDPKRPELGQGLATKAPDALRKKLQLFLGLLAFALSHPNRLLKSLATT-HKLVR
      GKLKDQEREIFARLTASAPPAIAHPALTGDMATLMEAVLLMPLLAALLTVLPLEPLDKAY
      EDDSPGDILAVYAVF--
      >N3613
      LGRGMARTTVEDLETVLNATMDRFAQLPYDGSLQRDDTTAASAPLGTLYGKSPTADMFLQ
      FALESYLDPKRPELGQGLATKAPDALRKRLQLYLGLLSFALEHPTPLLQSLATTLHK-VR
      GKLKNLQREVFARLTASAASGIAHPALTGDMATLMDAVLLMPLLAKLLTIIILEPLDKKY
      SDNSPDDILAAYAAFLS
      >N1689
      MKLGRYRTVQTANEKYLETTAGRYADQNYAGTAQRGVQKANSVPLGTLYPDLPTRDMLLL
      VSLESYLESITAGL-AGLATKAVTLFKVVLVLFLSVTGFALSHPGELFLSMAAVLQTEIR
      GKLKNLTRELLQKLSASLTAGLAVPELTGDEASLGAGKILVPLLAALLVALLLSPLLGGF
      SDDLPNMVLAIYAVTL-
      >N3700
      MKMGRPRTKQSTSQRYLDTAGARYDDQAYAGTLQRGLGNAKGVPLGTLYLDFPIRDMLLL
      VTLESYLESIVAGLYA-GATKAPNLLQAVLILFLNVVGFALLHPGALLLTMAAVLHNELI
      GKLKEFSRELLERLAASVITGLAVPELTGDEGTLAAGVILMALLAALLLYLLLDPLLSGF
      SGDLPDSGLAVHA----
    EOS
    system bin"VeryFastTree", "test.fasta"
  end
end