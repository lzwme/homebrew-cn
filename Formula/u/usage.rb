class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "aa5e9b7eb904c31276112e808bb80f90d8218261ca0102379efc8793486073ed"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3b7800a0f70a0d8eb7673c3e764c81cd462927bdd2e0166f37f4973716a29e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ef5a1cf325ab112e7efba1e47b82072e8561195b6091b1419cfa2cd77249a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4deb596cf99f7c86c3a93e65f63b5f8cfe1c62b9c0957527145be178b1a838ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "323597000e26694c4e3582eb529200e64d96302849f854758b51af14eb229151"
    sha256 cellar: :any,                 arm64_linux:   "6e08999c5156a5294d03153794d0ecba4f5e2dfa503f905b005b5c9f492452b9"
    sha256 cellar: :any,                 x86_64_linux:  "64dee1591f7ff725df660a98e16aa056f62ca253150bae7cb8bcd0b18efe73fb"
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