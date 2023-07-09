class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://ghproxy.com/https://github.com/jbangdev/jbang/releases/download/v0.109.0/jbang-0.109.0.zip"
  sha256 "50cd3a82b85017e98c8e589c4b3a4e5c98dbfe49d2e6f3623f3c8864cafd1637"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "487ef7128b3a7ac2416ffbf62144d9c94c4feefd4efc5c57a9bcfb533c19eb92"
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