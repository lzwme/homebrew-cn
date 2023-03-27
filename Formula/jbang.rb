class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://ghproxy.com/https://github.com/jbangdev/jbang/releases/download/v0.105.2/jbang-0.105.2.zip"
  sha256 "7b5ce3f8cc9c7aae422f2a5a18fc27af005b36c767ae48abe9ede232d5b8eaf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa57f3690f79c810a389bc9e0481bdfa501f7cc1cbf1b65c23859d533f990b95"
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