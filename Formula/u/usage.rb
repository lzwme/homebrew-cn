class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "bf4fb91d99507af61a9bee7ef2da9ba264284cdc5ef400414c9a1c63b8bd28c8"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e41ca0821b9f904f1f96d270d22cd93592d10eca1224ed8543253578e3b47320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20243bfd7ea22ebae0fb1db4660076ec9f06bde3fddf902cad0aa91923e20db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ddf2cb4854f88eab821fd16cfc504ba042a3fe847f4fee06f3843b8ab46695"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0d54552e6d4d624b9f5a6481d02f8d2e8e58df1ce6dcf2d24c011cf4fea86b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5808f08ef84576001b1fc2459ff96204937293c63585b5bd38cf30883ca43854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a509f11ccf1ca19234ddacb71021ecd943a2ee87e941b7f267737b4fdcecda4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end