class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "https:itstool.org"
  url "https:files.itstool.orgitstoolitstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e1e9d99c5a31ea0ba1c10156fcaf66a36f03e63292644a2835f85c0f44fad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90e1e9d99c5a31ea0ba1c10156fcaf66a36f03e63292644a2835f85c0f44fad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90e1e9d99c5a31ea0ba1c10156fcaf66a36f03e63292644a2835f85c0f44fad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ded43403a913a90938fd73895bf4b3ebff6af37ec34f12f800d466ba47c688"
    sha256 cellar: :any_skip_relocation, ventura:       "45ded43403a913a90938fd73895bf4b3ebff6af37ec34f12f800d466ba47c688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e1e9d99c5a31ea0ba1c10156fcaf66a36f03e63292644a2835f85c0f44fad5"
  end

  head do
    url "https:github.comitstoolitstool.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libxml2"
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefixLanguage::Python.site_packages(python3)

    configure = build.head? ? ".autogen.sh" : ".configure"
    system configure, "--prefix=#{libexec}", "PYTHON=#{which(python3)}"
    system "make", "install"

    bin.install Dir[libexec"bin*"]
    bin.env_script_all_files libexec"bin", PYTHONPATH: ENV["PYTHONPATH"]
    pkgshare.install_symlink libexec"shareitstoolits"
    man1.install_symlink libexec"sharemanman1itstool.1"
  end

  test do
    (testpath"test.xml").write <<~EOS
      <tag>Homebrew<tag>
    EOS
    system bin"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end