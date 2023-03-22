class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://ghproxy.com/https://github.com/jbangdev/jbang/releases/download/v0.105.1/jbang-0.105.1.zip"
  sha256 "ea16b8470242ba6f4f2bfe1b3758fa1b1793ce7bdae722ee191cc4d9143f8b4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63ce21caaa0a2e24b71f79249399b3a6e6095999f7c9cc6c764074e862cfe1df"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end