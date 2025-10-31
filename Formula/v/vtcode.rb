class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.37.1.crate"
  sha256 "bddd5488eef052d41a3d03ef82623fa07f19c1686faccbb661d1315989ec7d9a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9144a385b7945e2394a579adab8d957ddc0b172f1f0bacbbfa215c798124721c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66c9b2a8ca2c1bdbfd60b193df823afea892ddea3b2125279bd9c10bf0264be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b263ffda0b2a09cded85a5ff0fac9a8e9a6dc6340408b98bc948d858156e88b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d8b05773cc594b2e986550f709db2cfeaa56f36c688e39d1619bcd23cd023b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23732cb19a4b5023bf816d8d9f5bec9ad1580a20ab10a035916d285c82c8f2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b483c8f657df3210b9cfdcf7ff78e8ba671e98d9a6a1c2afd72c73f289a30ec4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end