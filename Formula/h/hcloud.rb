class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.45.0.tar.gz"
  sha256 "9c98d25b2d41dedf6fdd9f48781c553e325d9c82b2fc2c7137b243e9f04ad155"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f694daa445430fb65f95ccc6865f80a7f9f3356cb9906b51a6e08f9f5e62c08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ba9fd2db45c361618f986ac8807e24052e3ca3714f1c1c05193b985556d5f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "803fa69a1d7476bbc18feefb5bf5404108fae227108efe230db4f4c13fa8ae00"
    sha256 cellar: :any_skip_relocation, sonoma:         "2816bc6779f825276c10dbd8e6edff0ddf60678ffbe893bb3d5ec37bd15dab42"
    sha256 cellar: :any_skip_relocation, ventura:        "6f5afc116e0c1c9ccbdf413cdf0a2999bee67a6f1bb56ed85b00b82665108528"
    sha256 cellar: :any_skip_relocation, monterey:       "9dba77138633fd5a3fbef698162d5c9a212cee956e48e03286ef7bf4f11e9d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6eabec906e4feb4d366ac30c219460c62d579e09e3f3a75cfe6c42a3754771"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhetznercloudcliinternalversion.version=v#{version}
      -X github.comhetznercloudcliinternalversion.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhcloud"

    generate_completions_from_executable(bin"hcloud", "completion")
  end

  test do
    config_path = testpath".confighcloudcli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}hcloud context list")
    assert_match "test", shell_output("#{bin}hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}hcloud version")
  end
end