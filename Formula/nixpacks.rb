class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "31de314e5d41e414afd524af3ece7c199cec0c241cb6f596cfd2272c9e7f5687"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1bdfee944226b3041f7f18f0d7f24b3f476ae5309bad6221baacf67144cfaa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9080f9bea48fb9254c8dc1b5886ad58f1941293cdc166600878fc1ddfcd7f4b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0334cd4cc3eb1f7a2292fd3495b6943126743d40706965a1fda93815e7dd6e06"
    sha256 cellar: :any_skip_relocation, ventura:        "d0633c2f989b3ecc8ee0b22575e23210dffec0be2df13df92bec64835ab00991"
    sha256 cellar: :any_skip_relocation, monterey:       "9bf8602b32a16a3586a4a80690874ea22a807ebeebc949829b7641c4a536afaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbff78e674c55d856bfd948f2daf6a51d4c901ec5e372f9de8aad683fd896653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb758b8131fc5c9d13187a630b133303fcfb6976d9d4286aec8edf25987b0d0"
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