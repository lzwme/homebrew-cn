class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https:keptn.sh"
  url "https:github.comkeptnkeptnarchiverefstags1.4.4.tar.gz"
  sha256 "96fa4b0c903a582c1be02dc48b13d2ac86e45f583116d0402fcd71f4a033afbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ccb4f60d9df1efb53d8f7295e8482faf31125339cd3210dd4882f428753a51e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce0c359ebb4eae50af87da12bd5f622cdaff7dca0d6f28cd6e6523316eaa8b12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94bbacc45c27fec1e3f1b82423ce74f2691c1ebbaa5c63faf5642fcb390f1ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "12d7e8725f57c33c15857153d55ad35a1a87a5e84bb2ce6c7e1c5b395d2765d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5b5801136b59038fcd2a8837e2e803de41bc17ad795dc2efead95d7416ddec4f"
    sha256 cellar: :any_skip_relocation, monterey:       "09443a938287f912fdff68e2c1511fec6cd26e0ffb5f20ecd84639d2906e66f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d075520a64f2b3762e469b2b8b177b660cd768e035b596aebcb4bf4bd17c2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkeptnkeptnclicmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin"keptn version 2>&1")

    output = shell_output(bin"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn.keptn____keptn: no such file or directory", output
    end
  end
end