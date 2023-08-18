class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https://github.com/hashicorp/packer/pull/12568
  url "https://ghproxy.com/https://github.com/hashicorp/packer/archive/v1.9.3.tar.gz"
  sha256 "d13035521bb352b79fe9a09a0cb84f5d0a4619df06f71a5f8c22fbe6fbf922a4"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7685aa2f4637c450de60ccf1c69186c72c84804269a40c1f16c047dbc1e00f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08eea891e84c8f88be209a0b557ed1ec0d43ca373113e786cc970c9a49020527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "926d115f302f6fd34e32a3e477717dbb87508b942e8b150b8894c8f9a830996b"
    sha256 cellar: :any_skip_relocation, ventura:        "b09a35dd63bab32512fa9f1adc6812366f5d706771df5adf4a17ee09dfa2121b"
    sha256 cellar: :any_skip_relocation, monterey:       "d01c35158a660f72515c8bb81329883a401fba5c0aa06bde084054021aa0c33b"
    sha256 cellar: :any_skip_relocation, big_sur:        "078b7a54742fda1800871f1f968a80f84a49d2d5bebb3751db4d66685ee8d56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be94e2c61d8f46bcd91e62c13c2c9ab10381f42f895f12f4adb76846c2f9204"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Allow packer to find plugins in Homebrew prefix
    bin.env_script_all_files libexec/"bin", PACKER_PLUGIN_PATH: "$PACKER_PLUGIN_PATH:#{HOMEBREW_PREFIX/"bin"}"

    zsh_completion.install "contrib/zsh-completion/_packer"
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<~EOS
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", "-syntax-only", minimal
  end
end