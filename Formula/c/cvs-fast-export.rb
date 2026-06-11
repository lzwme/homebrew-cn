class CvsFastExport < Formula
  include Language::Python::Shebang

  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "https://gitlab.com/esr/cvs-fast-export/-/archive/2.1/cvs-fast-export-2.1.tar.bz2"
  sha256 "1fd660ddccbeba8f4514ca4268a234be4fb6e3ad6370574b865e4720cd876f68"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1a28987df0517bcef7fec664e1c2ecc6b85ecbf14816f958523f77ed89c7658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a28987df0517bcef7fec664e1c2ecc6b85ecbf14816f958523f77ed89c7658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a28987df0517bcef7fec664e1c2ecc6b85ecbf14816f958523f77ed89c7658"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c891f5cd1f694e55e3faf758d2a02033cdd1ae6bbcf454c343e7ef3a1e441d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b1db898718bf60129280d96119e1f14cdd95da002aa4d4b1710d651d6ed82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0098d3debbbd34751c019cfba95503b5ce7db3cce1aa731479f39293c0e8d1e"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "cvs" => :test

  uses_from_macos "python"

  def install
    system "make", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    man1.install buildpath.glob("*.1")
    bin.install "cvsconvert", "cvssync"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *bin.children
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