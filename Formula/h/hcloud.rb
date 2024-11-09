class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https:github.comhetznercloudcli"
  url "https:github.comhetznercloudcliarchiverefstagsv1.49.0.tar.gz"
  sha256 "5b238acf908046205c15c7b720efeed51f50f56c8c0b0bf6d0f9022e1536392d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13efd789d8c373536fec0a1191252ad3da86a005404116a585aa1a6b4f426f9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13efd789d8c373536fec0a1191252ad3da86a005404116a585aa1a6b4f426f9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13efd789d8c373536fec0a1191252ad3da86a005404116a585aa1a6b4f426f9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3863bd0dc0f8af8d38bb1564779031891faf6d49a12caef448e16520d894cb"
    sha256 cellar: :any_skip_relocation, ventura:       "ff3863bd0dc0f8af8d38bb1564779031891faf6d49a12caef448e16520d894cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30d38f525e00c5bdae662deeab26c3349407a771044202311ce7b569277f189"
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