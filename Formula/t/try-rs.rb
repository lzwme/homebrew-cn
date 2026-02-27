class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "cda296e5f56eb62fd72296b631795c9419188d01cf66cca0c1453b108344e05f"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64506ae75731af71afb67916ffacf968005f794b47b439daa432e03ddbafd2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881160048abeffc02528e49d087e6e5192e938fc5f8971b5ed42898e8baabaec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b0c23f956368605494d0f9dafe7e492fee807e7d5cc8b847b6a31df443271a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6bb52108c10892a8c8f1c39748ff3f6d84d9ed7fa9a6cbe19f70b666e867f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5351613a4799852371af16a400996ce5b8395664499154d2bd42347c373194e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8d9cb9d8ada72271b42686db777a389ee5db2cd11abc7763f76f32b2c0251c"
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