class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "3d54cf1ff1b189ed27008f1fb0ba815b60697431de8237826f1a1dc6f96a680b"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6533da26969712e4021f725f8627587c313e22956cd44c08fb6afe052263b67e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f624fbcc17259384e61c698a16c231483968930056013d526617e29ac57ffdac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a88b199f8e36ae1ac53b8917ce2307587e8b77b9c57436526aace0f87178b313"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7b8dbb9326854752b8a1e930581494b8596b1ab679bce0953a711723a61981"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d073a41c63ee89f6954b1a53b7012dd6c0d9eac1c4661a3f2901f65b1b0fd052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a881f03ffc2195687025c5d0e7a0f64a3c2b03218ffdabd17539a78d56a0b1"
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