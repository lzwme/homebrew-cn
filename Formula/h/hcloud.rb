class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/v1.38.2.tar.gz"
  sha256 "807d17d4f3a6d0a5d1558b8e79a555b5ab048325060001e8d5f0762b64e2dfb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85f5e600b7f6de08f2d6e607bf4a9a3d08d3ba91fad03a78b858c304fc1f8fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fc9482c00c8a65d8aed9fda5b7e29be67266307a87af99b206d6dd7ec6196c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6540f76903e638ce5b6795f7f03c6ba2da740517217bee70806e375aad5478f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "917da9cee2f9371770202c6d8f65628658130faeadb82ea4cd123c9ddf423268"
    sha256 cellar: :any_skip_relocation, ventura:        "b78b7e8a8b00c08a0bb05734835e21129d9d8eca581b4275f027cc0e96c78dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f89a12047af98ea5a356c04f90571af0480ae8ff8f9f213326814905ff38c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "236a5dd4fcb3b6df817e9c2a60d136e52c9a5910af6fc3b7d0f30bd2c17d6433"
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