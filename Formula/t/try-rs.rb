class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "296f99be61945227abbc2c639159c859e5e09b07a94d96eac8da1e682cf1cc20"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bfa2fd2990a06ca599b6e2c2dd0b3a6b2cfb7ca284b56a563b3ec35a3cffd21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2181d96bf205086bb1b95a7d88a555802a8c5aaac2827a9af038529b6e85a11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4aed30ecfe604f5f45ffc8ff7b12f5d773973ae8aab76ed26e6625271452feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0d1e06ca3aff54e9717458f1b27512d73a5794e4ed6dded00148ec2fc4c27c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc409a72ea25a2909b001c79953fce52cdf57a1cf3fe431da9764b79a677559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48878b401eb12037b6714c823f7be6bc01ea8261366d5f55493aa7e3d7561a21"
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