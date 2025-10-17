class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "https://itstool.org/"
  url "https://files.itstool.org/itstool/itstool-2.0.7.tar.bz2"
  sha256 "6b9a7cd29a12bb95598f5750e8763cee78836a1a207f85b74d8b3275b27e87ca"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://itstool.org/download.html"
    regex(/href=.*?itstool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "6a85d08730bddc99c0d9b2aef09627193c8b7fcc432a5bdc64fd04da448ee2ad"
  end

  head do
    url "https://github.com/itstool/itstool.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libxml2"
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefix/Language::Python.site_packages(python3)

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--prefix=#{libexec}", "PYTHON=#{which(python3)}"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"]
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"

    # Check for itstool data files in HOMEBREW_PREFIX. This also ensures uniform bottles.
    inreplace libexec/"bin/itstool" do |s|
      s.sub! "'.local', 'share'", "'.local', 'share', 'itstool'"
      s.sub! "/usr/local/share", "#{HOMEBREW_PREFIX}/share/itstool"
      s.sub! "/usr/share", "/usr/share/itstool"
      s.sub! "ddir, 'itstool', 'its'", "ddir, 'its'"
    end
  end

  test do
    (testpath/"test.xml").write <<~XML
      <tag>Homebrew</tag>
    XML
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end