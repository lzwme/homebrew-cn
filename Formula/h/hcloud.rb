class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghfast.top/https://github.com/hetznercloud/cli/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "ba798a4449d448053986e5ef69344a6ee205d3ee90a024560d755ca9e6063d7d"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "024f06608feff047736c4db16396b2ce0a189a48319ab0e5987e0fad46974690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c097e044fbfaaaa7fb31272311b86fa700ece0d80c1f8a4920d601e30102508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7b9f619a2ce1cedd9d26e20768d22b89e93e681392532363ed5ad2002e72805"
    sha256 cellar: :any_skip_relocation, sonoma:        "4501333556aca50a54b9d78f109b6c67539d24c7b5b8af377a5a1a9ffef3c895"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b9c9f79552846af00c07210ff941e9eed06a0599854db3d74a85983aed021c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8895261a22197730265c42355b5a9759d800272d1b2f9dfd23a4fca32363d3d4"
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