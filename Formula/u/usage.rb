class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.1.1.tar.gz"
  sha256 "6a91ce2c344c8a4576d2bff616033b3f8118f7ecb8b984332cb77fd462ed7894"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08683faf8d8a39ffb7fda80ea3f5405296346d440d85a7a4eea4d0f4c627a091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4024290bf0b47acd9cc170a3f52a1fff335e2a8682fb75dd90d04357b9937f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3c1d1e522ad8667fccbef05b09a7407d0625a79cc98b712ae0558efa774c2bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0de9a6f247f71c2d5e649bfd17dd0c958de2fec1012fb21704678a4bc6033739"
    sha256 cellar: :any_skip_relocation, ventura:       "a406540b4a25046cfc5e225674a3fb2d3b0df49a6820f5115e3c2df33dd6f7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "013339cc0d635ad6b5387a365e0bb188b6d321f39ea77e62b236b135ed1b11fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end