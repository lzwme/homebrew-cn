class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "43604a5c0734386643bdf481e43ca513228a88280081829f7f5b5a031a82a7eb"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2902fb71e5b16252301233dba6b1e84f5be6f618bcb7dd79c29096ff11b7a615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7b6038815cc26503c5a02587fbf96337f4078965bc030ce662fa9f48c45572"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e50db42b8d053f53654368a6e3a97c4955e6db0b03f5ab4fd597b03b8f0b564"
    sha256 cellar: :any_skip_relocation, ventura:        "164023fee0c10961cba8c3285ebd13fa2b07e13e15b3bf53b2373525ac563f86"
    sha256 cellar: :any_skip_relocation, monterey:       "00e9cd7db6bbfcbf80253f8fb3797c86c9262f5317c2bad1584f33c2d4916beb"
    sha256 cellar: :any_skip_relocation, big_sur:        "926bab525d031058c859bd4d5d198febe70e3ec21c2263c6236000d4cc649119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9af8bca851affc1c77974c4b28691dec7f89203286f11f381075830145cc6913"
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