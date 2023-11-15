class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "74d65f21e1d123bf30a3a4ad4cfa517c241dd56af559b3f88433b97c2a8b26aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51ee4aa6f068d0970fd7a32ae81dc7c646ca4e6b8671244f2b474163dae00354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef173eacedb86b3595e689cc609c2c766258ac8b3648759399e32e5e677470db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af7813b7cdddfb7096cd0483331e17f0d430f89f4d7151239fe595bb1ee890fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "c57f7536d895349c3f43e7fc8c6561ca38406620a21fbc77fd561d0cd9330e4b"
    sha256 cellar: :any_skip_relocation, ventura:        "b5de38561cdce2ee4dca590d8e099163f13ebc62189088ed62769c841eb85e02"
    sha256 cellar: :any_skip_relocation, monterey:       "47ab236cf85696a1b3ca2b8556180b1b06eeaace13d78ad65097e55d7132aedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6ab0ae8c73fd495078ec401371fbd762f9fd4bb7fd045f04d31162e9ed36c40"
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