class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/v1.34.0.tar.gz"
  sha256 "0227354afb8b68a690f49f96ce9a2dac1ff5f38a66efe255750ef9db6db44c37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21443a94c0f59b3a513a09e60cb300248dd525429c401d34318b6af0912ddd4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21443a94c0f59b3a513a09e60cb300248dd525429c401d34318b6af0912ddd4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21443a94c0f59b3a513a09e60cb300248dd525429c401d34318b6af0912ddd4e"
    sha256 cellar: :any_skip_relocation, ventura:        "4cdd2b7614e981737fbe483b349bf9dfbd8de28e9ff0fef49ba5719d7b077bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "4cdd2b7614e981737fbe483b349bf9dfbd8de28e9ff0fef49ba5719d7b077bb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cdd2b7614e981737fbe483b349bf9dfbd8de28e9ff0fef49ba5719d7b077bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6179632884d6fbc9997926de307138f7840b62a0101e486b49d17222c6ef962"
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