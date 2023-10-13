class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/v1.38.0.tar.gz"
  sha256 "063379d6abcbf4b22380221a7c4d3c66b6ccfbeb843e281145710a9ae95d5319"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bae8cea77f1bb776f187c31406fb6f7bf01d1faf895546eb9b7d596e9dae2091"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28ca4a2190e1ff6c5414a2649bc922ef77f47e01b2efa3417d40ca3fe1c05ba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de2b679bc7e3b4bc9f977c4fd905c7d1fe00bcb1b5c12ec90407b5287c987d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cfe39fe36b54f4f922be4be0c4a83217362223846a35a74319da397f64f8267"
    sha256 cellar: :any_skip_relocation, ventura:        "954f2b58a0c9c7b084f64e202aecc3b04ec56e90769081dc0e3b1585a3532848"
    sha256 cellar: :any_skip_relocation, monterey:       "cea5f43e4c4f893c4a42db14325c9294755e0d871e61a6199e00ee3af07aa2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7689b611afee6371e6ca0b3bdc3227a971c1a2ad887c6f87e141cb78b0da8f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end