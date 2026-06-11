class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7855477d96fe9db89fbb8bb874a09c1dd94eaf1bc121a76c20355b3b3ebb2f03"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5845c45d1a1e709f1a5d49816748638540a1df68474a923612408fd317f7e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef8734378ba36c03544ff348b620c026143f694269b8b634a736c1a648db23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9a65d4e56fcbd317abe4cdc0e4a4c4d862a914e7907634a6e634f2a74648436"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9599ce6e634ac855868400487e4282ba4905b552addf2df4565d90568d10cf7"
    sha256 cellar: :any,                 arm64_linux:   "ff7cad23d722b93b0f7bb38a090546a7ecf6c16686c3bf63c63bcd105f5b9d3a"
    sha256 cellar: :any,                 x86_64_linux:  "32d3eae70f7b559460baa305b1e469e1297a217a482632674aa0b4f6625cfdaa"
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