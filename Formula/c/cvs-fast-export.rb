class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.64.tar.gz"
  sha256 "c70ec229991d118412a1c243a3c8130c85367a294ffeb3136dff30bd88b685a5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5c0cfd5886c0aaaaf5767eab0a9c3711dc65078e04992f02f06ef84a57fc3c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a45b13525f55c32d0836bff4412893aa675de7d60f17db068be8c9e0c1828e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cb503e7295bba683b4bdea6f2c2b16716e36c57b20bce90d7d229c742ee740d"
    sha256 cellar: :any_skip_relocation, sonoma:         "35fa0c88d45a315add0520107c76430a5b94db966f41648970cc6523494bd162"
    sha256 cellar: :any_skip_relocation, ventura:        "c372e408f1a89aa0b5183969f3802e1baf2cb7b07065fb41ffd591a18d024a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "3062b12d22818e5ca684ca10369a3ac7b6aae652b43a9e5ff4aac22450427a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752c4ea1d3ec85b3d6fc362be4c616a7c839b2016959ec27c5377afbd998d8bc"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"
    depends_on "bison" => :build
  end

  depends_on "asciidoctor" => :build
  depends_on "cvs" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "cvs", "-d", cvsroot, "init"

    test_content = "John Barleycorn"

    mkdir "cvsexample" do
      (testpath/"cvsexample/testfile").write(test_content)
      ENV["CVSROOT"] = cvsroot
      system "cvs", "import", "-m", "example import", "cvsexample", "homebrew", "start"
    end

    assert_match test_content, shell_output("find #{testpath}/cvsroot | #{bin}/cvs-fast-export")
  end
end