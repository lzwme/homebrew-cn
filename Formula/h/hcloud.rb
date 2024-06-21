class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.44.0.tar.gz"
  sha256 "cf8c8b6c22019b1ba6b9fcb8e175ec09d0f15dc472316fea7edd4fab78db709c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "132cc6f16c5f029d8d4d4e574da1bd90c4b2da109e062cd10ee32dde3dfa3398"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aba5962ef624be30e9d4c350347e224706d2c8a0efbc701c00963c6bcf849e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2742c1f959bf1ff60e29384350c54765494fd364d17353fad7907ddc472e2a00"
    sha256 cellar: :any_skip_relocation, sonoma:         "efdbf41130aeba60f6c58b2ba0be7fed5fc6b35d23c9c1ddac4dc41a22a09653"
    sha256 cellar: :any_skip_relocation, ventura:        "48a3789d5966eeba9ea6dede82479b5d250180081e110b3d3a02209541695b15"
    sha256 cellar: :any_skip_relocation, monterey:       "0f19bd29dc4add76d5ac9d87c686ef6a7cbb861c325e609ef5e5538a12a20cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e999776638f123182f8112d349d27bec0f8ab63a0a47ce5a9dac017d81831080"
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