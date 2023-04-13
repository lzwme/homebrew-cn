class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/v1.33.0.tar.gz"
  sha256 "8b1758e1a25a61e59c6027477b9c582f2df8afd9d399701cd4196f33db0d85c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eabcc4e95af270dc954a9e44d46c5ee86c049b2548d07c1518f8a83f3a593160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eabcc4e95af270dc954a9e44d46c5ee86c049b2548d07c1518f8a83f3a593160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eabcc4e95af270dc954a9e44d46c5ee86c049b2548d07c1518f8a83f3a593160"
    sha256 cellar: :any_skip_relocation, ventura:        "279cb624f520d878ab6197dc01bae8d44f2f9121ad4a5e97fb68afb152cae7af"
    sha256 cellar: :any_skip_relocation, monterey:       "279cb624f520d878ab6197dc01bae8d44f2f9121ad4a5e97fb68afb152cae7af"
    sha256 cellar: :any_skip_relocation, big_sur:        "279cb624f520d878ab6197dc01bae8d44f2f9121ad4a5e97fb68afb152cae7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020b21ede8a2a42026b396291add7873ac51fb3db73f6941dd242d49d44be749"
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