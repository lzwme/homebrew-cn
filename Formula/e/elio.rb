class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://ghfast.top/https://github.com/elio-fm/elio/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0c22cbbaf2d79edef3ee8bfd17e44a6273164d2090c30e05004fed259a3d689e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "610260cb8357eb7dc38545bf6e90806a85a5b36e8d4a597dde367922a7196bf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d14cff6c7fc805ced157e78c1f5d024369818d84b1d0ae2185e5efae0140a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a9b5b246a9ea06428444e255fb1a193186984db1b4c3c2d9054be3612f551d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0aef5520a066cb4eeda87a2193059966cdc93c2cfd5622df8be310a8a1832d5"
    sha256 cellar: :any,                 arm64_linux:   "92dedd6b8fc29f039451df5611f7cc9c2f27531c083dc65f3580f393e1ea3d9e"
    sha256 cellar: :any,                 x86_64_linux:  "79bb059984004d10d6b5fdf6427ce9bdc43ff46e02a8c2307223a22a499af91e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end