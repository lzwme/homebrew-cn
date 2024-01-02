class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.63.tar.gz"
  sha256 "61917641e6d66ef9ff37da4ba5c72e759b051f3a1c269ff73341b1f69edf4396"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f18f636a3f1a142adb3f57a1c390dec9ef55b582bb72f136c44d307a5eaee79e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06eb09786d4a68ed650f3635c72cc14b5cca292878def1f217f654d90e6e3f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dcd82128bc71f8e0fca49047d1be193722be7f4a28448dab7736b665af9bb6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fb5d208f4503898270d861b77f89f479abafc9256702d2e36b980dd84e0f5c7"
    sha256 cellar: :any_skip_relocation, ventura:        "6bdfecdc68cc6bcc5e3460a3fe7e7b3c095bd750cf39c0d3b8ce5b930dd4faca"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc1af1e52ff399c6a40ad3788ae26631491f22c8408ed9961cad40aebe0e17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819b4c4e553d82e356af8da36d5951d69f1c96c804325d0f20bce8c698598728"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"
    depends_on "bison" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
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