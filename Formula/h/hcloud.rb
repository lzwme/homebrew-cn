class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "f2ee4b068f5f0c8f79d9e5647ff868237f919c0d2cf6f2a6e0f6fbeafa8f8032"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "091ba14f25b85b7d570a041a3161a448f10a0afd962aa7f35dbd1f95918130c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535efbcb8b8af1348ea9031a462bcd1a6bbf247ca9896c7ea478c5f477df08e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8576f218d0b9d73022f2539a3fff6a6d7ebf5fde7705730cca05a698a7882af4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d7a5dec01f5317d157deb3b225e0d8f5d6f065d0904b6b4410b6cdd39675b44"
    sha256 cellar: :any_skip_relocation, ventura:        "e636aadb17e385c673cdcd47eea76506abdce1c04c17b4249c3c64fe0f8fcaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3733f37f9b794e8cd2d98b96ae4f8827eca97d62dc092ffb378340a883a36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ddec1be7add9b6ddcaab83c314a1a135bc889ca2b63b540f08dc8dcd00c27c"
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