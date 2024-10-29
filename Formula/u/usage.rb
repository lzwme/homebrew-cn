class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.0.0.tar.gz"
  sha256 "e06a46cbb763864edb50741043fdd62cd6e1f42a9e5a2c7a3abaa499c0b08a48"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ac26c9101fada32bd27a69190330284b723d9aba2a6b5c3d97058e6b64a3b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9bdcf42f3be22615113c1b9a53e91e0dfba22e4374a69f0df77a20a8c1bc6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05b170e95e8d47f3477e1cf2f8297a1bf2176ea1d93777925acf15b0929cdb26"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb63aab7f635d79c9ff02fe3bf9e83bb3e16696755db498da06df4f678b72445"
    sha256 cellar: :any_skip_relocation, ventura:       "bf246635ab207cdb59636f6c9031096894d54015b252ea675b9a58dcb86a7f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d13db610ffa5e48e755f8c0c4db241155c9c60b8c329357295398e7d9f4091"
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