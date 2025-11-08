class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghfast.top/https://github.com/hetznercloud/cli/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "3426285a22b1a8aa5b63d47dc1447cb79dbf10fb7c9b9ae7a9e345e8668c9a59"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7c0eadc337839e4f5de696f24a79efca43492678f2300f3f5325975592fb2e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775f783abf9c5b35db0624d30c180b9b8e8bd460b130fb7486500d720b4a7847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8126ae9526f585ef5c7df7ba49daee54be7cae65bfcbea1f59dac32814d9a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba49bf7ebfb3a6d823a7e41c1ed74b052a83be82dedb644b360e38571dd79dea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b93bdace270efbb47f82dc39bac6604cf9f4125e52e736dfffd9191eecf6b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9517b85c5bad517b1a83bc2e6965e716c0b7cbdafe6176ba5437a687cfec0848"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

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