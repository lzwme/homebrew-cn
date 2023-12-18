class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https:github.commonsieurvideoget-flash-videos"
  url "https:github.commonsieurvideoget-flash-videosarchiverefstags1.25.99.03.tar.gz"
  sha256 "37267b41c7b0c240d99ed1f5e7ba04d00f98a8daff82ac9edd2b12c3bca83d73"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad7d390da6c1be03c3de2e092694f00b52c9ab7904bd0d6077113a144c7cace4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d868b0de04638b31496b1eade51c9d4c482d2d3dc96414a29e5b32e93fce112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed15861be06bfdb23115de813dc02c7518d4c1f04ecd47c6fe01e3ecddd25de4"
    sha256 cellar: :any_skip_relocation, sonoma:         "36c2d69e934ed8768b4f826acb7a644e88a33de80b1394dbd858144c8e8a1ad2"
    sha256 cellar: :any_skip_relocation, ventura:        "0211c7949bc8379c91fd941e9880e5932d5e4c33caad811a98239ab6fe4fcc08"
    sha256 cellar: :any_skip_relocation, monterey:       "de42f123f13f8e838ea63a756015eea195ac1817637a85a7cef66e38a2e94b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d196f6695aef76cf0d3fb4db79f423c4a4987963e0f9fdf91d40236d044c09"
  end

  depends_on "rtmpdump"

  uses_from_macos "openssl"
  uses_from_macos "perl"

  on_linux do
    resource "Module::Find" do
      url "https:cpan.metacpan.orgauthorsidCCRCRENZModule-Find-0.13.tar.gz"
      sha256 "4a47862072ca4962fa69796907476049dc60176003e946cf4b68a6b669f18568"
    end

    resource "Try::Tiny" do
      url "https:cpan.metacpan.orgauthorsidEETETHERTry-Tiny-0.28.tar.gz"
      sha256 "f1d166be8aa19942c4504c9111dade7aacb981bc5b3a2a5c5f6019646db8c146"
    end

    resource "XML::Simple" do
      url "https:cpan.metacpan.orgauthorsidGGRGRANTMXML-Simple-2.24.tar.gz"
      sha256 "9a14819fd17c75fbb90adcec0446ceab356cab0ccaff870f2e1659205dc2424f"
    end

    resource "HTTP::Request" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Message-6.37.tar.gz"
      sha256 "0e59da0a85e248831327ebfba66796314cb69f1bfeeff7a9da44ad766d07d802"
    end

    resource "URI" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSURI-5.10.tar.gz"
      sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
    end

    resource "LWP::UserAgent" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSlibwww-perl-6.67.tar.gz"
      sha256 "96eec40a3fd0aa1bd834117be5eb21c438f73094d861a1a7e5774f0b1226b723"
    end

    resource "HTTP::Date" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end

    resource "HTML::Form" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTML-Form-6.07.tar.gz"
      sha256 "7daa8c7eaff4005501c3431c8bf478d58bbee7b836f863581aa14afe1b4b6227"
    end

    resource "HTML::TokeParser" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTML-Parser-3.78.tar.gz"
      sha256 "22564002f206af94c1dd8535f02b0d9735125d9ebe89dd0ff9cd6c000e29c29d"
    end

    resource "HTML::Tagset" do
      url "https:cpan.metacpan.orgauthorsidPPEPETDANCEHTML-Tagset-3.20.tar.gz"
      sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
    end

    resource "LWP::Protocol::https" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSLWP-Protocol-https-6.10.tar.gz"
      sha256 "cecfc31fe2d4fc854cac47fce13d3a502e8fdfe60c5bc1c09535743185f2a86c"
    end

    resource "Net::HTTP" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSNet-HTTP-6.22.tar.gz"
      sha256 "62faf9a5b84235443fe18f780e69cecf057dea3de271d7d8a0ba72724458a1a2"
    end

    resource "IO::Socket::SSL" do
      url "https:cpan.metacpan.orgauthorsidSSUSULLRIO-Socket-SSL-2.074.tar.gz"
      sha256 "36486b6be49da4d029819cf7069a7b41ed48af0c87e23be0f8e6aba23d08a832"
    end

    resource "Net::SSLeay" do
      url "https:cpan.metacpan.orgauthorsidCCHCHRISNNet-SSLeay-1.92.tar.gz"
      sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
    end

    resource "HTTP::Cookies" do
      url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Cookies-6.10.tar.gz"
      sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
    end

    resource "Encode::Locale" do
      url "https:cpan.metacpan.orgauthorsidGGAGAASEncode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "XML::Parser" do
      url "https:cpan.metacpan.orgauthorsidTTOTODDRXML-Parser-2.46.tar.gz"
      sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
    end
  end

  resource "Crypt::Blowfish_PP" do
    url "https:cpan.metacpan.orgauthorsidMMAMATTBMCrypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSlibwww-perl-6.33.tar.gz"
    sha256 "97417386f11f007ae129fe155b82fd8969473ce396a971a664c8ae6850c69b99"
  end

  resource "Tie::IxHash" do
    url "https:cpan.metacpan.orgauthorsidCCHCHORNYTie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSWWW-Mechanize-1.88.tar.gz"
    sha256 "36d97e778ab911ab5a762d551541686cbf3463c571f474322f7b5da77f50a879"
  end

  resource "Term::ProgressBar" do
    url "https:cpan.metacpan.orgauthorsidMMAMANWARTerm-ProgressBar-2.21.tar.gz"
    sha256 "66994f1a6ca94d8d92e3efac406142fb0d05033360c0acce2599862db9c30e44"
  end

  resource "Class::MethodMaker" do
    url "https:cpan.metacpan.orgauthorsidSSCSCHWIGONclass-methodmakerClass-MethodMaker-2.24.tar.gz"
    sha256 "5eef58ccb27ebd01bcde5b14bcc553b5347a0699e5c3e921c7780c3526890328"
  end

  resource "Crypt::Rijndael" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTCrypt-Rijndael-1.13.tar.gz"
    sha256 "cd7209a6dfe0a3dc8caffe1aa2233b0e6effec7572d76a7a93feefffe636214e"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    unless OS.mac?
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix
    end

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib"perl5"
    system "make"
    (lib"perl5").install "bliblibFlashVideo"

    bin.install "binget_flash_videos"
    bin.env_script_all_files(libexec"bin", PERL5LIB: ENV["PERL5LIB"])
    chmod 0755, libexec"binget_flash_videos"
    # Replace cellar path to perl with opt path.
    if OS.linux?
      inreplace libexec"binget_flash_videos",
                Formula["perl"].bin.realpath,
                Formula["perl"].opt_bin
    end

    man1.install "blibman1get_flash_videos.1"
  end

  test do
    assert_match "Filename: BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv",
      shell_output("#{bin}get_flash_videos --info http:news.bbc.co.uk2hiprogrammeshardtalk9560793.stm")
  end
end