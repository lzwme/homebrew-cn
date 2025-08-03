class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://ghfast.top/https://github.com/j178/prefligit/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "d5533dce84a02e4f731c95215b003d7e11b87c2fa9c54ccf40df65c5bd983f37"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a97381e95c9acbd08d24d863bb0cbd00bd912aec9ba255cd7acde573a88f65c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a0b44c8aa6851daab785964b166254fa49a9bb9df5a4ad4d143e9624bbcc3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d5932dc63511319828bf0c7121a570ce6b39ecba9fd225559427731cd938dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49e0dad5999a568c829b2894b4bb2d1b39b726463c257c01099ae35e6449d72"
    sha256 cellar: :any_skip_relocation, ventura:       "9f831ff8301b2cc4828672a42dc9e9df87b58ab90ddbbad4a9a376282b175d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ebe925f8aa936235a0165889a889a7b8e734055bc5637c7773d7cc3292d582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5b8b5de9c805a5396ac8fa81bddeedd3a78e32b23bb9d6c1c80eb8e4dcfdef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prefligit", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end