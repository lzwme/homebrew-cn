class Paneru < Formula
  desc "Sliding, tiling window manager for MacOS"
  homepage "https://github.com/karinushka/paneru"
  url "https://ghfast.top/https://github.com/karinushka/paneru/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "068ecede1ac04a1ae9ca096d52b713d11c1f04250471836863d958ce9deb6e6e"
  license "MIT"
  head "https://github.com/karinushka/paneru.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b47300970bf71e80ad07618058aa6d7b0f9d7ef0dd0832b50910f910f692db0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5fc00ddae3192450ec1d76de3b7e9643cdf3e2b0449e8dc63a3892611e3665d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcc502904732e69e2fea7bd872392862f4c4bcd9b5a0d3946380fab6a395f988"
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