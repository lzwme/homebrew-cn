class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "3e16ea8d2d213036f19cb34c5d778d4e8d9d9bb9a92fd9138a61d507488f4ccf"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9937c8afa51ee2cd031967375a6ce95d26d1904c605c12a98f381471616e8e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "684e32d2f32c58ad1eac07cd071a7e40174f099cfbcd39be2de414b995962dc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "582504e61d773f854c33fa6097eb0f362322a120491298598cb22a5b7c57242a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f70cdf124bc860ecda41424fc7ed795b4a54484d4eee041ca840dd493818a995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f849002d7a9e55ddeb8a463ebe3d7baa696cfd8c5655a0d2fadb81a54be8a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00da4f5f5f8ee0b933f0186339372fac5d4ea6b3765c4142b5b8dff577641293"
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