class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https:jbang.dev"
  url "https:github.comjbangdevjbangreleasesdownloadv0.126.2jbang-0.126.2.zip"
  sha256 "abf2a4341b13612d093bec4a6564a5b54bc1e3ba4805c8e40e521347a6f7f73b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d17e41036c04ab5758cda3175161f0ee20490e708b6aa53ce49b1ef95309bb56"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}binjbang", ^abs_jbang_dir=.*, "abs_jbang_dir=#{libexec}bin"
    bin.install_symlink libexec"binjbang"
  end

  test do
    system bin"jbang", "init", "--template=cli", testpath"hello.java"
    assert_match "hello made with jbang", (testpath"hello.java").read
    assert_match version.to_s, shell_output("#{bin}jbang --version 2>&1")
  end
end