require "languageperl"

class Po4a < Formula
  include Language::Perl::Shebang

  desc "Documentation translation maintenance tool"
  homepage "https:po4a.org"
  url "https:github.commquinsonpo4aarchiverefstagsv0.73.tar.gz"
  sha256 "ad5edc38bf004807843622fddbf67bd5ac604fc16e14c2bfefa7b07718ad21f3"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.commquinsonpo4a.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afb479bc9624626a1f950a4f201fda2d5e959b59f414b0d87b6a6e8cc2baaae4"
    sha256 cellar: :any,                 arm64_sonoma:  "2d74dc1e677bfaf935771544981f7f44ffdd3b5f661e0df07748e5c71849420a"
    sha256 cellar: :any,                 arm64_ventura: "7a4016850542e5ab42173906e8ed86d13fe971b7161103ca49abb787fbdad05c"
    sha256 cellar: :any,                 sonoma:        "aea5106a47029e857b9c5ec0ac0a87e87b4cf7843717251df7b41a0461b84a34"
    sha256 cellar: :any,                 ventura:       "b0c068aac3d53b27fde2125a35bc474b019e5fc3cee5102d1c2b0b3a32a708e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c667b5f9d44d0d116b73b0524d100d362aa202a414c69ee6ce06f68ae9ae0f70"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "perl"

  uses_from_macos "libxslt"

  resource "Locale::gettext" do
    url "https:cpan.metacpan.orgauthorsidPPVPVANDRYLocale-gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  resource "Module::Build" do
    url "https:cpan.metacpan.orgauthorsidLLELEONTModule-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "Pod::Parser" do
    url "https:cpan.metacpan.orgauthorsidMMAMAREKRPod-Parser-1.67.tar.gz"
    sha256 "5deccbf55d750ce65588cd211c1a03fa1ef3aaa15d1ac2b8d85383a42c1427ea"
  end

  resource "SGMLS" do
    url "https:cpan.metacpan.orgauthorsidRRARAABSGMLSpm-1.1.tar.gz"
    sha256 "550c9245291c8df2242f7e88f7921a0f636c7eec92c644418e7d89cfea70b2bd"
  end

  resource "Term::ReadKey" do
    url "https:cpan.metacpan.orgauthorsidJJSJSTOWETermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  resource "Text::WrapI18N" do
    url "https:cpan.metacpan.orgauthorsidKKUKUBOTAText-WrapI18N-0.06.tar.gz"
    sha256 "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488"
  end

  resource "Unicode::GCString" do
    url "https:cpan.metacpan.orgauthorsidNNENEZUMIUnicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "YAML::Tiny" do
    url "https:cpan.metacpan.orgauthorsidEETETHERYAML-Tiny-1.74.tar.gz"
    sha256 "7b38ca9f5d3ce24230a6b8bdc1f47f5b2db348e7f7f9666c26f5955636e33d6c"
  end

  resource "ExtUtils::CChecker" do
    url "https:cpan.metacpan.orgauthorsidPPEPEVANSExtUtils-CChecker-0.12.tar.gz"
    sha256 "8b87d145337dec1ee754d30871d0b105c180ad4c92c7dc0c7fadd76cec8c57d3"
  end

  resource "XS::Parse::Keyword::Builder" do
    url "https:cpan.metacpan.orgauthorsidPPEPEVANSXS-Parse-Keyword-0.42.tar.gz"
    sha256 "7e498879e7813c9a7ecf4296c74774a32e40131e3a64efcc63c8010c0eb11382"
  end

  resource "Syntax::Keyword::Try" do
    url "https:cpan.metacpan.orgauthorsidPPEPEVANSSyntax-Keyword-Try-0.29.tar.gz"
    sha256 "cc320719d3608daa9514743a43dac2be99cb8ccd989b1fefa285290cb1d59d8f"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    ENV.prepend_path "PERL5LIB", libexec"lib"

    resources.each do |r|
      r.stage do
        if File.exist?("Makefile.PL")
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system ".Build"
          system ".Build", "install"
        end
      end
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"

    system "perl", "Build.PL", "--install_base", libexec
    system ".Build"
    system ".Build", "install"

    shell_scripts = %w[po4a-display-man po4a-display-pod]

    %w[msguntypot po4a po4a-display-man po4a-display-pod
       po4a-gettextize po4a-translate po4a-normalize po4a-updatepo].each do |cmd|
      rewrite_shebang detected_perl_shebang, libexec"bin"cmd unless shell_scripts.include? cmd

      (bincmd).write_env_script(libexec"bin"cmd, PERL5LIB: ENV["PERL5LIB"])
    end

    man1.install Dir[libexec"manman1{msguntypot.1p.gz,po4a*}"]
    man3.install Dir[libexec"manman3Locale::Po4a::*"]
    man7.install Dir[libexec"manman7*"]
  end

  test do
    # LaTeX

    (testpath"en.tex").write <<~'TEX'
      \documentclass[a4paper]{article}
      \begin{document}
      Hello from Homebrew!
      \end{document}
    TEX

    system bin"po4a-updatepo", "-f", "latex", "-m", "en.tex", "-p", "latex.pot"
    assert_match "Hello from Homebrew!", (testpath"latex.pot").read

    # Markdown

    (testpath"en.md").write("Hello from Homebrew!")
    system bin"po4a-updatepo", "-f", "text", "-m", "en.md", "-p", "text.pot"
    assert_match "Hello from Homebrew!", (testpath"text.pot").read
  end
end