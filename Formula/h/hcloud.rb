class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghfast.top/https://github.com/hetznercloud/cli/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "ba798a4449d448053986e5ef69344a6ee205d3ee90a024560d755ca9e6063d7d"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d742b9574a9ff6cdce3a2450ae3c08dabcc29d3e843db4f3a056d0634a01a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f7755d26f9fa33bb628c83e4391c9c704b7abfc238f338698e47ab2c75c9bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5309ffb239960d5155e124958009e245b75e89b76494930ee6b51e765fe323bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e4e550bbd23f5f7a56125f97e58486fe170a28ff4953f3c5428735b549d100b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ecb3a2f609328b09512eef44c9e269ca5f4c59a00e988c63dc8572e78711e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6dc7ce9c4579ab6c9c151e5dff08c934153c5ccb30d3b63070421cb7fc6f22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
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