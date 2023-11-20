class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://ghproxy.com/https://github.com/jbangdev/jbang/releases/download/v0.112.4/jbang-0.112.4.zip"
  sha256 "a52ead8eb46958685318a5c7c0c88bcdd4913670a16f3cdf470198ceffd09269"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84a96e5f252e360bae4c6a935edd8a743e876be8c5065b0049f582cebcc6f30b"
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