class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https:jbang.dev"
  url "https:github.comjbangdevjbangreleasesdownloadv0.115.0jbang-0.115.0.zip"
  sha256 "51cbeee30e0c9d2ec50085777f4adc93eed77f2dfde0be37075926718b9bc0e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f33f64dfa4a4cff3fd21fc49908f4d1e15ac6439f202d606395871f25d010257"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}binjbang", ^abs_jbang_dir=.*, "abs_jbang_dir=#{libexec}bin"
    bin.install_symlink libexec"binjbang"
  end

  test do
    system "#{bin}jbang", "init", "--template=cli", testpath"hello.java"
    assert_match "hello made with jbang", (testpath"hello.java").read
    assert_match version.to_s, shell_output("#{bin}jbang --version 2>&1")
  end
end