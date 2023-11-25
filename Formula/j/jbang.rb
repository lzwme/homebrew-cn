class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://ghproxy.com/https://github.com/jbangdev/jbang/releases/download/v0.113.0/jbang-0.113.0.zip"
  sha256 "f176f5c3521affbde8b11c12f1f36ae827d17b7717e416b4fdcf0fe70fa8c235"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4bcbc43c79b9e4ca7a36a2bd4492adf172fc41aeee86a6415b8a87e33bfd43e0"
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