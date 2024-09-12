class Latexindent < Formula
  desc "Add indentation to LaTeX files"
  homepage "https:latexindentpl.readthedocs.io"
  url "https:github.comcmhugheslatexindent.plarchiverefstagsV3.24.4.tar.gz"
  sha256 "7b7216604d1e544b7f22cf520b3ca1817222e70e28fe2865bcc4d0e3284c497c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d534cd3e3721d0714d5b4d36a1aabef1cc2c970aeb863cd8c175f5811d884506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b04582bc3af70d9b42d800a00e3203fb498c6f9cbb9f1882cd65bd2998302c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a139417ac37daa84a1c07f563157cb63fbb0b2fb5a34f610c96dc6ae0c8526e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f3fc5462d9bfae6801a589f29eecc338f49c1a7100c38274ecf114bc7cf7519"
    sha256 cellar: :any_skip_relocation, sonoma:         "109ef109bba008c2574dc99a81a5eea0377dbc7aaa40b9b7cf0426235038b785"
    sha256 cellar: :any_skip_relocation, ventura:        "b8537550b090777911270e933fc33911f3af2ef5de4b320b0abd1a8703c41c41"
    sha256 cellar: :any_skip_relocation, monterey:       "9d29972ec35a4f252b261e334cc9898e7933a780cc4045b9f0cded45b10a0867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217da1f566d0196dfed633e6b722d9e5ea39b1fa31f288973215dacafe9f8086"
  end

  depends_on "perl"

  resource "Mac::SystemDirectory" do
    on_macos do
      url "https:cpan.metacpan.orgauthorsidEETETHERMac-SystemDirectory-0.14.tar.gz"
      sha256 "b3c336fe20850042d30e1db1e8d191d3c056cc1072a472eb4e5bd7229056dee1"
    end
  end

  resource "B::Hooks::EndOfScope" do
    url "https:cpan.metacpan.orgauthorsidEETETHERB-Hooks-EndOfScope-0.28.tar.gz"
    sha256 "edac77a17fc36620c8324cc194ce1fad2f02e9fcbe72d08ad0b2c47f0c7fd8ef"
  end

  resource "Class::Data::Inheritable" do
    url "https:cpan.metacpan.orgauthorsidRRSRSHERERClass-Data-Inheritable-0.09.tar.gz"
    sha256 "44088d6e90712e187b8a5b050ca5b1c70efe2baa32ae123e9bd8f59f29f06e4d"
  end

  resource "Devel::GlobalDestruction" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGDevel-GlobalDestruction-0.14.tar.gz"
    sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
  end

  resource "Devel::StackTrace" do
    url "https:cpan.metacpan.orgauthorsidDDRDROLSKYDevel-StackTrace-2.05.tar.gz"
    sha256 "63cb6196e986a7e578c4d28b3c780e7194835bfc78b68eeb8f00599d4444888c"
  end

  resource "Dist::CheckConflicts" do
    url "https:cpan.metacpan.orgauthorsidDDODOYDist-CheckConflicts-0.11.tar.gz"
    sha256 "ea844b9686c94d666d9d444321d764490b2cde2f985c4165b4c2c77665caedc4"
  end

  resource "Eval::Closure" do
    url "https:cpan.metacpan.orgauthorsidDDODOYEval-Closure-0.14.tar.gz"
    sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
  end

  resource "Exception::Class" do
    url "https:cpan.metacpan.orgauthorsidDDRDROLSKYException-Class-1.45.tar.gz"
    sha256 "5482a77ef027ca1f9f39e1f48c558356e954936fc8fbbdee6c811c512701b249"
  end

  resource "File::HomeDir" do
    url "https:cpan.metacpan.orgauthorsidRREREHSACKFile-HomeDir-1.006.tar.gz"
    sha256 "593737c62df0f6dab5d4122e0b4476417945bb6262c33eedc009665ef1548852"
  end

  resource "File::Which" do
    url "https:cpan.metacpan.orgauthorsidPPLPLICEASEFile-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "Log::Dispatch" do
    url "https:cpan.metacpan.orgauthorsidDDRDROLSKYLog-Dispatch-2.71.tar.gz"
    sha256 "9d60d9648c35ce2754731eb4deb7f05809ece1bd633b74d74795aed9ec732570"
  end

  resource "Log::Log4perl" do
    url "https:cpan.metacpan.orgauthorsidEETETJLog-Log4perl-1.57.tar.gz"
    sha256 "0f8fcb7638a8f3db4c797df94fdbc56013749142f2f94cbc95b43c9fca096a13"
  end

  resource "MIME::Charset" do
    url "https:cpan.metacpan.orgauthorsidNNENEZUMIMIME-Charset-1.013.1.tar.gz"
    sha256 "1bb7a6e0c0d251f23d6e60bf84c9adefc5b74eec58475bfee4d39107e60870f0"
  end

  resource "MRO::Compat" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGMRO-Compat-0.15.tar.gz"
    sha256 "0d4535f88e43babd84ab604866215fc4d04398bd4db7b21852d4a31b1c15ef61"
  end

  resource "Module::Build" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTModule-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "Module::Implementation" do
    url "https:cpan.metacpan.orgauthorsidDDRDROLSKYModule-Implementation-0.09.tar.gz"
    sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
  end

  resource "Module::Runtime" do
    url "https:cpan.metacpan.orgauthorsidZZEZEFRAMModule-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end

  resource "Package::Stash" do
    url "https:cpan.metacpan.orgauthorsidEETETHERPackage-Stash-0.40.tar.gz"
    sha256 "5a9722c6d9cb29ee133e5f7b08a5362762a0b5633ff5170642a5b0686e95e066"
  end

  resource "Package::Stash::XS" do
    url "https:cpan.metacpan.orgauthorsidEETETHERPackage-Stash-XS-0.30.tar.gz"
    sha256 "26bad65c1959c57379b3e139dc776fbec5f702906617ef27cdc293ddf1239231"
  end

  resource "Params::ValidationCompiler" do
    url "https:cpan.metacpan.orgauthorsidDDRDROLSKYParams-ValidationCompiler-0.31.tar.gz"
    sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
  end

  resource "Role::Tiny" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGRole-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "Specio" do
    url "https:cpan.metacpan.orgauthorsidDDRDROLSKYSpecio-0.48.tar.gz"
    sha256 "0c85793580f1274ef08173079131d101f77b22accea7afa8255202f0811682b2"
  end

  resource "Sub::Exporter::Progressive" do
    url "https:cpan.metacpan.orgauthorsidFFRFREWSub-Exporter-Progressive-0.001013.tar.gz"
    sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
  end

  resource "Sub::Identify" do
    url "https:cpan.metacpan.orgauthorsidRRGRGARCIASub-Identify-0.14.tar.gz"
    sha256 "068d272086514dd1e842b6a40b1bedbafee63900e5b08890ef6700039defad6f"
  end

  resource "Sub::Quote" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGSub-Quote-2.006008.tar.gz"
    sha256 "94bebd500af55762e83ea2f2bc594d87af828072370c7110c60c238a800d15b2"
  end

  resource "Test::Fatal" do
    url "https:cpan.metacpan.orgauthorsidRRJRJBSTest-Fatal-0.017.tar.gz"
    sha256 "37dfffdafb84b762efe96b02fb2aa41f37026c73e6b83590db76229697f3c4a6"
  end

  resource "Try::Tiny" do
    url "https:cpan.metacpan.orgauthorsidEETETHERTry-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end

  resource "Unicode::LineBreak" do
    url "https:cpan.metacpan.orgauthorsidNNENEZUMIUnicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "Variable::Magic" do
    url "https:cpan.metacpan.orgauthorsidVVPVPITVariable-Magic-0.64.tar.gz"
    sha256 "9f7853249c9ea3b4df92fb6b790c03a60680fc029f44c8bf9894dccf019516bd"
  end

  resource "XString" do
    url "https:cpan.metacpan.orgauthorsidAATATOOMICXString-0.005.tar.gz"
    sha256 "f247f55c19aee6ba4a1ae73c0804259452e02ea85a9be07f8acf700a5138f884"
  end

  resource "YAML::Tiny" do
    url "https:cpan.metacpan.orgauthorsidEETETHERYAML-Tiny-1.74.tar.gz"
    sha256 "7b38ca9f5d3ce24230a6b8bdc1f47f5b2db348e7f7f9666c26f5955636e33d6c"
  end

  resource "namespace::autoclean" do
    url "https:cpan.metacpan.orgauthorsidEETETHERnamespace-autoclean-0.29.tar.gz"
    sha256 "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804"
  end

  resource "namespace::clean" do
    url "https:cpan.metacpan.orgauthorsidRRIRIBASUSHInamespace-clean-0.27.tar.gz"
    sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    resources.each do |r|
      r.stage do
        args = ["INSTALL_BASE=#{libexec}"]
        args.unshift "--defaultdeps" if r.name == "MIME::Charset"
        system "perl", "Makefile.PL", *args
        system "make", "install"
      end
    end

    (libexec"libperl5").install "LatexIndent"
    (libexec"bin").install "latexindent.pl"
    (libexec"bin").install "defaultSettings.yaml"
    (bin"latexindent").write_env_script(libexec"binlatexindent.pl", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{latexindent Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      \\item Hello
      \\item World
      \\end{itemize}
      \\end{document}
    EOS
    assert_match <<~EOS, shell_output("#{bin}latexindent #{testpath}test.tex")
      \\documentclass{article}
      \\title{latexindent Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      	\\item Hello
      	\\item World
      \\end{itemize}
      \\end{document}
    EOS
  end
end