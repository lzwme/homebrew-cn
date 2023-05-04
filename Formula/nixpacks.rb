class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7e937ed480f989cac7a632716d88b3d09d392f9af8f7a5d4b7b550da616e47fe"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "845b32bec7ef6e818d49c4dd25cdf441d54bc3411bc386a67b970b410ee119db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ff013fb88e8047aa5872fb395037cca265407dc1656c4d78fee9540b62f39c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecb47e23966539e46b9e4d1a776ce28be6bbf2ba8ad3259082031035717da2c4"
    sha256 cellar: :any_skip_relocation, ventura:        "993ebcef0e39a00c990c1168bf4cbd3ee6e20386622d61c3164bdd3e5a67b236"
    sha256 cellar: :any_skip_relocation, monterey:       "e057a1b100c32e6e9fb67db34eb5810443a71f3d7cfb1606b8c50be1e7868b17"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a74339773b2ebfb33aef95f575d938ea5798c1e14554b82b148f578b47155f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f854047f3ababf19f3ec6f929ee2617c907b7e2745e92c38c98d4d2d5f9cd925"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end