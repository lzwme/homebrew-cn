class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.44.1.tar.gz"
  sha256 "55d03bd692bbae15c0bd3784986df3345d9019f510be20462abf954c533c69d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7867930e20eae7a4b1ef291e940cf5d9671fca10874356f4490a0414c862fe81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e8877b7c46666374c9016eb2c15d8e6b2287bff5dc669d71079434269e5030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d20293c8e5b74039757de818d1c916e4b5cc9fce10a70370e419999c3ddf988"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5dfbaf7849cc26e3c8059828d44762ad0ea8480aa1cdcfd586655b459394292"
    sha256 cellar: :any_skip_relocation, ventura:        "5de8023c8af2872a4fa56bcbc500493f8b7252b005f8640434b38050d306fdaa"
    sha256 cellar: :any_skip_relocation, monterey:       "ffccd24408eb460be46534cc6261a189f5d5fe03407c60f8c85503c2d7cdd88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9982e4b9897aa154f679c91791b69da8b2f806fa0ea3b41e9f294b7c03e33d9"
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