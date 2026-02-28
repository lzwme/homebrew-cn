class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "87adbbc9f3ee99833ecf87573edb3d72e7f2fccc9c7c506b2e56999b89532a0c"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92cb869873d44c2cce2e8ae046fb13b1bba27020a5a96cfedbf0e8da8a44d3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8f258e186791d869eeadfe9f921124a1a8a01494b52c7effc0043c63d7a159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85f707bcf088534ccb1a19d3ad2201cc2de8a016adf05b36390c48b5231aebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e450edc166e3f3fb99953793d754802b810a8cb4cf012977f792d05b9a130737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a4f03ffa51a5d94fb5508ec4e339941b88afcf69722d4794970f559a13cd76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c3ab7ba7825d212e43429c54f7785ec458970d3ec7911e325f620ba5ecc59a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end