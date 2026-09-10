class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://ghfast.top/https://github.com/karinushka/paneru/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1ad4628505d110e2656bd454fbf6566522ca19e1a8dec3196450b15788c248dd"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "861e0ed47183703b878e646027858036e9e3eedce58e62074acf0678e54f2c6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766c5806811cbba89cde33f7f0425d31d9ffa7b5dce605dbd966a5b87a0aa54e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ec11d779f6e47143dc2b3869a91e6451b32c96adccc567d5245dbda4dcf192"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  # The test verifies that the binary has been correctly installed.
  # Once the binary is installed, the user will have to:
  # - Configure the initial configuration file.
  # - Start the binary directly or install it as a service.
  # - Grant the required AXUI priviledge in System Preferences.
  test do
    assert_match version.to_s, shell_output("#{bin}/paneru --version")
  end
end