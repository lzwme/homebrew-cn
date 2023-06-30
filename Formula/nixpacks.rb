class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "8d9a93f3254d87f2f066adabc78272b8186f3088fd8fb35b67dd57d8c1d19bf4"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80289734036830c05a71c3c0aad4b021e229b7dcba8738a42bb313f21ae843ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55d0d71c0867d58e9723aae2a4d1d70c92925fa7d4cb1f01c7b262c496583de3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "468cdcd5292fce7af4e1920d0082d8703ecc55ba5e08c9e8582156634f92966e"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab6a666ed27e7a56fb598b8a80ec34b8be11b1c04415446dc3b3d028165fd90"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca081966809d1439394c6a517d9d7286a712675acc74148634778db69fa501a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbbc0820b2932b307a08fa51a476df07ee68525227a2c80b633dfcaaabe62e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80fb859c53e1c13083f34a9c965aea8a82a614c56f14ae782a33d3a0199af99"
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