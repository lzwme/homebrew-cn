class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.99.tar.gz"
  sha256 "01628722f584057ae71a6a731511f4b8c527b80a88b4d0d9be83fa23cd73848c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c803065613bed5d886f60b4b2cce10f4c53ad867cf4870d3ea65c2ebbbc09a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af968ca60cadaf74057393409da1ae6684ccaeb5c96ed1ab2f4c691cc921b875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b2a297818a511297b1df1921e2dcc8fdc9499cf29b049341d4831cea4db32a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e22b6b1a6ac172ad1953ab3c16dbd58dddc9db192ee2a3b9ae076b47ebe1e68f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f916377b8c878f41463e7626fddafbd1b37dc354397d65f1ea921e4a6ee16637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71aab27657835016643dd27588e757d77c419ae560e211f74428bef00d25de9"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end