class Texlive < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Free software distribution for the TeX typesetting system"
  homepage "https:www.tug.orgtexlive"
  url "https:ftp.math.utah.edupubtexhistoricsystemstexlive2025texlive-20250308-source.tar.xz"
  mirror "https:ftp.tu-chemnitz.depubtughistoricsystemstexlive2025texlive-20250308-source.tar.xz"
  sha256 "fffdb1a3d143c177a4398a2229a40d6a88f18098e5f6dcfd57648c9f2417490f"
  license :cannot_represent
  revision 1
  head "https:github.comTeX-Livetexlive-source.git", branch: "trunk"

  livecheck do
    url "https:ftp.math.utah.edupubtexhistoricsystemstexlive"
    regex(href=.*?texlive[._-]v?(\d+(?:\.\d+)*)[._-]source\.ti)
    strategy :page_match do |page, regex|
      # Match years from directories
      years = page.scan(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
                  .flatten
                  .uniq
                  .map { |v| Version.new(v) }
                  .sort
      next if years.blank?

      # Fetch the page for the newest year directory
      newest_year = years.last.to_s
      year_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, newest_year).to_s)
      next if year_page[:content].blank?

      # Match version from source tarball filenames
      year_page[:content].scan(regex).flatten
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "dbb0b1a2a0b1d06263f2fe4e1b386cc2f682c4ab3a5d399b65cbfb3ce33ce4eb"
    sha256 arm64_sonoma:  "e071d59282304b7664e026649c7b9d83df65202d5a558f0064cc58ee1415c03c"
    sha256 arm64_ventura: "bf3f81f2101f658532f917b49cdb220c21e6b5465f27f0fcdefa4b361d0f119c"
    sha256 sonoma:        "e0353127249a2ac7229787cdd7f2a555f115c9b2ff466f4e339557117c59a664"
    sha256 ventura:       "b065a0aa04c54fdef596148f0fcae226fc38cd8bfca6632dd194bc04121ad0de"
    sha256 arm64_linux:   "5124fbe9981c8e14b7b505701a62a75671eff00c910b0af49acbc2cd8d0e56e8"
    sha256 x86_64_linux:  "6855a829bd2a7facbcaa400b2c3a5c342248abc606f479a538a03bbefdc6bacc"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "clisp"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gd"
  depends_on "ghostscript"
  depends_on "gmp"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "lua"
  depends_on "luajit"
  depends_on "mpfr"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "pixman"
  depends_on "potrace"
  depends_on "pstoedit"
  depends_on "python@3.13"

  uses_from_macos "ncurses"
  uses_from_macos "ruby"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libice"
    depends_on "libnsl"
    depends_on "libsm"
    depends_on "libxaw"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxmu"
    depends_on "libxpm"
    depends_on "libxt"
    depends_on "mesa"
  end

  conflicts_with "cweb", because: "both install `cweb` binaries"
  conflicts_with "lcdf-typetools", because: "both install a `cfftot1` executable"
  conflicts_with "ht", because: "both install `ht` binaries"
  conflicts_with "opendetex", because: "both install `detex` binaries"

  resource "texlive-extra" do
    url "https:ftp.math.utah.edupubtexhistoricsystemstexlive2025texlive-20250308-extra.tar.xz"
    mirror "https:ftp.tu-chemnitz.depubtughistoricsystemstexlive2025texlive-20250308-extra.tar.xz"
    sha256 "ea69cfecbc9b138acbc45476e8cb4d9357f5e4e45fd12b3bf9ceabbebd7669d2"
  end

  resource "install-tl" do
    url "https:ftp.math.utah.edupubtexhistoricsystemstexlive2025install-tl-unx.tar.gz"
    mirror "https:ftp.tu-chemnitz.depubtughistoricsystemstexlive2025install-tl-unx.tar.gz"
    sha256 "9938f192af75f792e84282580cce6eedac32969e0e07b33cb39ca1b699e948b6"
  end

  resource "texlive-texmf" do
    url "https:ftp.math.utah.edupubtexhistoricsystemstexlive2025texlive-20250308-texmf.tar.xz"
    mirror "https:ftp.tu-chemnitz.depubtughistoricsystemstexlive2025texlive-20250308-texmf.tar.xz"
    sha256 "08dcda7430bf0d2f6ebb326f1e197e1473d3f7cc0984a2adb7236df45316c7cf"
  end

  resource "Module::Build" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTModule-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "ExtUtils::Config" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTExtUtils-Config-0.010.tar.gz"
    sha256 "82e7e4e90cbe380e152f5de6e3e403746982d502dd30197a123652e46610c66d"
  end

  resource "ExtUtils::Helpers" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTExtUtils-Helpers-0.028.tar.gz"
    sha256 "c8574875cce073e7dc5345a7b06d502e52044d68894f9160203fcaab379514fe"
  end

  resource "ExtUtils::InstallPaths" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTExtUtils-InstallPaths-0.014.tar.gz"
    sha256 "ae65d20cc3c7e14b3cd790915c84510f82dfb37a4c9b88aa74b2e843af417d01"
  end

  resource "Module::Build::Tiny" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTModule-Build-Tiny-0.051.tar.gz"
    sha256 "74fdce35e8cd4d787bc2d4fc1d43a291b7bbced4e94dc5fc592bd81ca93a98e9"
  end

  resource "Digest::SHA1" do
    url "https:cpan.metacpan.orgauthorsidGGAGAASDigest-SHA1-2.13.tar.gz"
    sha256 "68c1dac2187421f0eb7abf71452a06f190181b8fc4b28ededf5b90296fb943cc"
  end

  resource "Try::Tiny" do
    url "https:cpan.metacpan.orgauthorsidEETETHERTry-Tiny-0.32.tar.gz"
    sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
  end

  resource "Path::Tiny" do
    url "https:cpan.metacpan.orgauthorsidDDADAGOLDENPath-Tiny-0.146.tar.gz"
    sha256 "861ef09bca68254e9ab24337bb6ec9d58593a792e9d68a27ee6bec2150f06741"
  end

  resource "File::Copy::Recursive" do
    url "https:cpan.metacpan.orgauthorsidDDMDMUEYFile-Copy-Recursive-0.45.tar.gz"
    sha256 "d3971cf78a8345e38042b208bb7b39cb695080386af629f4a04ffd6549df1157"
  end

  resource "File::Which" do
    url "https:cpan.metacpan.orgauthorsidPPLPLICEASEFile-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "IPC::System::Simple" do
    url "https:cpan.metacpan.orgauthorsidJJKJKEENANIPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  resource "URI" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSURI-5.31.tar.gz"
    sha256 "b9c4d58b2614b8611ae03a95a6d60ed996f4b311ef3cd5a937b92f1825ecc564"
  end

  resource "TimeDate" do
    url "https:cpan.metacpan.orgauthorsidAATATOOMICTimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end

  resource "Crypt::RC4" do
    url "https:cpan.metacpan.orgauthorsidSSISIFUKURTCrypt-RC4-2.02.tar.gz"
    sha256 "5ec4425c6bc22207889630be7350d99686e62a44c6136960110203cd594ae0ea"
  end

  resource "Digest::Perl::MD5" do
    url "https:cpan.metacpan.orgauthorsidDDEDELTADigest-Perl-MD5-1.9.tar.gz"
    sha256 "7100cba1710f45fb0e907d8b1a7bd8caef35c64acd31d7f225aff5affeecd9b1"
  end

  resource "IO::Scalar" do
    url "https:cpan.metacpan.orgauthorsidCCACAPOEIRABIO-Stringy-2.113.tar.gz"
    sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
  end

  resource "OLE::Storage_Lite" do
    url "https:cpan.metacpan.orgauthorsidJJMJMCNAMARAOLE-Storage_Lite-0.22.tar.gz"
    sha256 "d0566d6c29d397ea736379dc515c36849f6b97107cf700ba8250505c984cf965"
  end

  resource "Spreadsheet::ParseExcel" do
    url "https:cpan.metacpan.orgauthorsidJJMJMCNAMARASpreadsheet-ParseExcel-0.66.tar.gz"
    sha256 "bfd76acfba988601dc051bda73b4bb25f6839a006dd960b6a7401c249245f65b"
  end

  resource "Encode::Locale" do
    url "https:cpan.metacpan.orgauthorsidGGAGAASEncode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end

  resource "HTTP::Date" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Date-6.06.tar.gz"
    sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
  end

  resource "LWP::MediaTypes" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSLWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end

  resource "IO::HTML" do
    url "https:cpan.metacpan.orgauthorsidCCJCJMIO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end

  resource "HTTP::Request::Common" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Message-7.00.tar.gz"
    sha256 "5afa95eb6ed1c632e81656201a2738e2c1bc6cbfae2f6d82728e2bb0b519c1dc"
  end

  resource "HTML::Tagset" do
    url "https:cpan.metacpan.orgauthorsidPPEPETDANCEHTML-Tagset-3.24.tar.gz"
    sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
  end

  resource "HTML::Parser" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTML-Parser-3.83.tar.gz"
    sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
  end

  resource "HTML::TreeBuilder" do
    url "https:cpan.metacpan.orgauthorsidKKEKENTNLHTML-Tree-5.07.tar.gz"
    sha256 "f0374db84731c204b86c1d5b90975fef0d30a86bd9def919343e554e31a9dbbf"
  end

  resource "File::Slurper" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTFile-Slurper-0.014.tar.gz"
    sha256 "d5a36487339888c3cd758e648160ee1d70eb4153cacbaff57846dbcefb344b0c"
  end

  resource "Font::AFM" do
    url "https:cpan.metacpan.orgauthorsidGGAGAASFont-AFM-1.20.tar.gz"
    sha256 "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1"
  end

  resource "HTML::FormatText" do
    url "https:cpan.metacpan.orgauthorsidNNINIGELMHTML-Formatter-2.16.tar.gz"
    sha256 "cb0a0dd8aa5e8ba9ca214ce451bf4df33aa09c13e907e8d3082ddafeb30151cc"
  end

  resource "File::Listing" do
    url "https:cpan.metacpan.orgauthorsidPPLPLICEASEFile-Listing-6.16.tar.gz"
    sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
  end

  resource "HTTP::Cookies" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Cookies-6.11.tar.gz"
    sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
  end

  resource "HTTP::Daemon" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTTP-Daemon-6.16.tar.gz"
    sha256 "b38d092725e6fa4e0c4dc2a47e157070491bafa0dbe16c78a358e806aa7e173d"
  end

  resource "HTTP::Negotiate" do
    url "https:cpan.metacpan.orgauthorsidGGAGAASHTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end

  resource "Net::HTTP" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSNet-HTTP-6.23.tar.gz"
    sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
  end

  resource "WWW::RobotRules" do
    url "https:cpan.metacpan.orgauthorsidGGAGAASWWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "LWP" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSlibwww-perl-6.78.tar.gz"
    sha256 "b738bdcf54e2c6bb81fd2b83ec47bc83347f97b371ea80f0dc10360f817a9a44"
  end

  resource "CGI" do
    url "https:cpan.metacpan.orgauthorsidLLELEEJOCGI-4.67.tar.gz"
    sha256 "f4a6896eb94a3ecaa1c1ba02f7e0d2bed0be4c5ad3378d80196ec25662ac4111"
  end

  resource "HTML::Form" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSHTML-Form-6.12.tar.gz"
    sha256 "2ced87d0878afa007d22c41927f0e8da63844608f20881f645f364dc32cdce6f"
  end

  resource "HTTP::Server::Simple" do
    url "https:cpan.metacpan.orgauthorsidBBPBPSHTTP-Server-Simple-0.52.tar.gz"
    sha256 "d8939fa4f12bd6b8c043537fd0bf96b055ac3686b9cdd9fa773dca6ae679cb4c"
  end

  resource "WWW::Mechanize" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSWWW-Mechanize-2.19.tar.gz"
    sha256 "7b02e808018ff22a8798e51b5f329d8fac333fbfa8fb63808910091dade8b61f"
  end

  resource "Mozilla::CA" do
    url "https:cpan.metacpan.orgauthorsidLLWLWPMozilla-CA-20250202.tar.gz"
    sha256 "32d43ce8cb3b201813898f0c4c593a08df350c1e47484e043fc8adebbda60dbf"
  end

  resource "Net::SSLeay" do
    url "https:cpan.metacpan.orgauthorsidCCHCHRISNNet-SSLeay-1.94.tar.gz"
    sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
  end

  resource "IO::Socket::SSL" do
    url "https:cpan.metacpan.orgauthorsidSSUSULLRIO-Socket-SSL-2.089.tar.gz"
    sha256 "f683112c1642967e9149f51ad553eccd017833b2f22eb23a9055609d2e3a14d1"
  end

  resource "LWP::Protocol::https" do
    url "https:cpan.metacpan.orgauthorsidOOAOALDERSLWP-Protocol-https-6.14.tar.gz"
    sha256 "59cdeabf26950d4f1bef70f096b0d77c5b1c5a7b5ad1b66d71b681ba279cbb2a"
  end

  resource "Tk" do
    url "https:cpan.metacpan.orgauthorsidSSRSREZICTk-804.036.tar.gz"
    sha256 "32aa7271a6bdfedc3330119b3825daddd0aa4b5c936f84ad74eabb932a200a5e"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    python3 = "python3.13"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("pygments")

    # Install Perl resources
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    tex_resources = %w[texlive-extra install-tl texlive-texmf]

    resources.each do |r|
      next if tex_resources.include? r.name
      next if r.name == "pygments"

      r.stage do
        if File.exist? "Makefile.PL"
          args = ["INSTALL_BASE=#{libexec}"]
          args += ["X11INC=#{HOMEBREW_PREFIX}include", "X11LIB=#{HOMEBREW_PREFIX}lib"] if r.name == "Tk"

          system "perl", "Makefile.PL", *args
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system ".Build"
          system ".Build", "install"
        end
      end
    end

    # Install TeXLive resources
    resource("texlive-extra").stage do
      share.install "tlpkg"
    end

    resource("install-tl").stage do
      cd "tlpkg" do
        (share"tlpkg").install "installer"
        (share"tlpkg").install "tltcl"
      end
    end

    resource("texlive-texmf").stage do
      share.install "texmf-dist"
    end

    # Clean unused files
    rm_r(share"texmf-distdoc")
    rm_r(share"tlpkginstallerwget")
    rm_r(share"tlpkginstallerxz")

    # Set up config files to use the correct path for the TeXLive root
    inreplace buildpath"texkkpathseatexmf.cnf",
              "TEXMFROOT = $SELFAUTOPARENT", "TEXMFROOT = $SELFAUTODIRshare"
    inreplace share"texmf-distweb2ctexmfcnf.lua",
              "selfautoparent:texmf", "selfautodir:sharetexmf"

    # icu4c 75+ needs C++17
    # TODO: Remove in 2025 release
    ENV.append "CXXFLAGS", "-std=gnu++17"

    # Work around build failure on Intel Sonoma after updating to Xcode 16
    # sh: line 1: 27478 Segmentation fault: 11  luajittex -ini -jobname=luajittex -progname=luajittex luatex.ini ...
    ENV.O1 if DevelopmentTools.clang_build_version == 1600 && Hardware::CPU.intel?

    args = [
      "--disable-dvisvgm", # needs its own formula
      "--disable-missing",
      "--disable-native-texlive-build", # needed when doing a distro build
      "--disable-static",
      "--disable-ps2eps", # provided by ps2eps formula
      "--disable-psutils", # provided by psutils formula
      "--disable-t1utils", # provided by t1utils formula
      "--enable-build-in-source-tree",
      "--enable-shared",
      "--enable-compiler-warnings=yes",
      "--with-system-clisp-runtime=system",
      "--with-system-cairo",
      "--with-system-freetype2",
      "--with-system-gd",
      "--with-system-gmp",
      "--with-system-graphite2",
      "--with-system-harfbuzz",
      "--with-system-icu",
      "--with-system-libpng",
      "--with-system-mpfr",
      "--with-system-ncurses",
      "--with-system-pixman",
      "--with-system-potrace",
      "--with-system-zlib",
    ]
    args << "--with-banner-add=#{tap.user}" if tap

    args << if OS.mac?
      "--without-x"
    else
      # Make sure xdvi uses xaw, even if motif is available
      "--with-xdvi-x-toolkit=xaw"
    end

    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    system "make", "texlinks"

    # Create tlmgr config file.  This file limits the actions that the user
    # can perform in 'system' mode, which would write to the cellar.  'tlmgr' should
    # be used with --usermode whenever possible.
    actions = %w[
      candidates
      check
      dump-tlpdb
      help
      info
      init-usertree
      list
      print-platform
      print-platform-info
      search
      show
      version
    ]
    (share"texmf-configtlmgrconfig").write "allowed-actions=#{actions.join(",")}\n"

    # Delete some Perl scripts that are provided by existing formulae as newer versions.
    rm bin"latexindent" # provided by latexindent formula
    rm bin"latexdiff" # provided by latexdiff formula
    rm bin"latexdiff-vc" # provided by latexdiff formula
    rm bin"latexrevise" # provided by latexdiff formula

    # Wrap some Perl scripts in an env script so that they can find dependencies
    env_script_files = %w[
      crossrefwarebbl2bib.pl
      crossrefwarebibdoiadd.pl
      crossrefwarebibmradd.pl
      crossrefwarebiburl2doi.pl
      crossrefwarebibzbladd.pl
      crossrefwareltx2crossrefxml.pl
      ctan-o-matctan-o-mat.pl
      ctanifyctanify
      ctanuploadctanupload.pl
      exceltexexceltex
      latex-git-loglatex-git-log
      paxpdfannotextractor.pl
      ptex-fontmapskanji-fontmap-creator.pl
      purifyepspurifyeps
      svn-multisvn-multi.pl
      texdoctktexdoctk.pl
      ulqdaulqda.pl
    ]

    env_script_files.each do |perl_script|
      bin_name = File.basename(perl_script, ".pl")
      rm binbin_name
      (binbin_name).write_env_script(share"texmf-distscripts"perl_script, PERL5LIB: ENV["PERL5LIB"])
    end

    # Wrap some Python scripts so they can find dependencies and fix depythontex.
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    rm bin"pygmentex"
    rm bin"pythontex"
    rm bin"depythontex"
    (bin"pygmentex").write_env_script(share"texmf-distscriptspygmentexpygmentex.py",
                                       PYTHONPATH: ENV["PYTHONPATH"])
    (bin"pythontex").write_env_script(share"texmf-distscriptspythontexpythontex3.py",
                                       PYTHONPATH: ENV["PYTHONPATH"])
    ln_sf share"texmf-distscriptspythontexdepythontex3.py", bin"depythontex"

    # Rewrite shebangs in some Python scripts so they use brewed Python.
    python_shebang_rewrites = %w[
      dviasmdviasm.py
      latex-makefigdepth.py
      latex-makegensubfig.py
      latex-makelatexfilter.py
      latex-makesvg2dev.py
      latex-makesvgdepth.py
      latex-papersizelatex-papersize.py
      lilyglyphslilyglyphs_common.py
      lilyglyphslily-glyph-commands.py
      lilyglyphslily-image-commands.py
      lilyglyphslily-rebuild-pdfs.py
      pdfbook2pdfbook2
      pygmentexpygmentex.py
      pythontexdepythontex3.py
      pythontexpythontex3.py
      pythontexpythontex_install.py
      spixspix.py
      texliveonflytexliveonfly.py
      webquizwebquiz
      webquizwebquiz.py
      webquizwebquiz_makequiz.py
      webquizwebquiz_util.py
    ]

    python_shebang_rewrites.each do |python_script|
      rewrite_shebang detected_python_shebang, share"texmf-distscripts"python_script
    end

    # Delete ebong because it requires Python 2
    rm bin"ebong"

    # Initialize texlive environment
    ENV.prepend_path "PATH", bin
    system "fmtutil-sys", "--all"
    with_env(LUATEXDIR: share"texmf-distscriptscontextlua") do
      system "luatex", "--luaonly", "mtxrun.lua", "--generate"
    end
    system "mktexlsr"
  end

  test do
    assert_match "Usage", shell_output("#{bin}tex --help")
    assert_match "revision", shell_output("#{bin}tlmgr --version")
    assert_match "AMS mathematical facilities for LaTeX", shell_output("#{bin}tlmgr info amsmath")

    (testpath"test.latex").write <<~'LATEX'
      \documentclass[12pt]{article}
      \usepackage[utf8]{inputenc}
      \usepackage{amsmath}
      \usepackage{lipsum}

      \title{\LaTeX\ test}
      \author{\TeX\ Team}
      \date{September 2021}

      \begin{document}

      \maketitle

      \section*{An equation with amsmath}
      \begin{equation} \label{eu_eqn}
      e^{\pi i} + 1 = 0
      \end{equation}
      The beautiful equation \ref{eu_eqn} is known as Euler's identity.

      \section*{Lorem Ipsum}
      \lipsum[3]

      \lipsum[5]

      \end{document}
    LATEX

    assert_match "Output written on test.dvi", shell_output("#{bin}latex #{testpath}test.latex")
    assert_path_exists testpath"test.dvi"
    assert_match "Output written on test.pdf", shell_output("#{bin}pdflatex #{testpath}test.latex")
    assert_path_exists testpath"test.pdf"
    assert_match "This is dvips", shell_output("#{bin}dvips #{testpath}test.dvi 2>&1")
    assert_path_exists testpath"test.ps"
  end
end