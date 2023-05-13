class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://ghproxy.com/https://github.com/loichyan/nerdfix/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "03af7760d94bcb89f3de9a2b47294f0a9b1d0ae18580ab6ad0c1e4deec771e50"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92d6c4ca71a8cc6d43df5209fd73aa817e93030343339ce0c7f95bd821c62115"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33d41f113cb06cbe2425737a9c1830428b5a84e1a2c4405f96c50448ac57baf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2dd58c017856ab5423a9d2edfdefe7fa508d86a76ee774863ccbe4fbc83398b"
    sha256 cellar: :any_skip_relocation, ventura:        "90fcd5b3c76aebdc8bc4e2f3d5ede7711544e075650407e4855b357927967818"
    sha256 cellar: :any_skip_relocation, monterey:       "97c24a35398b0b326b731d31611b62d9f9f7cf9b77dd128f5d4e1802a876d033"
    sha256 cellar: :any_skip_relocation, big_sur:        "107443c40f8ecc1b8404d4f5fcff79603880cefff3311c1b59309f536196c516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1521f7f5d0bfd34f6a4a04ec2fdf4268a2214ed90a55968b0009da283c03524"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end