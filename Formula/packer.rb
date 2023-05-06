class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://ghproxy.com/https://github.com/hashicorp/packer/archive/v1.8.7.tar.gz"
  sha256 "0b3a45a3ecb0b5e993a0a39ee4599d69b58c1419cebddbfc45c61eb15389ba98"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a0ec062046941d59741377c5410f5a90dd6e64b5ca4db91e965a8510fe45c6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0884a3806b3364775b81f584cb8c8a0fd9046be6638fd785b36e5450c422d0ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a7d6ef20f5f613a7189f4663128b47437c0cccba120219bf9770cd28af9454d"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa105a984db69c7aba91a7e940a2d4177c3cf2677cd01a4f3157bfde91265e1"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca32ba384a4f169bec2f01e38e7dbd8e35c99be52c9012419829534b9f798a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeb6640bce66db5f76f69265862ee661e54d44689c155e18cb6bd27688a466ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c798bce3fcc38de591a148763dc48fa9911ca8d1e856bbcddaf9235383c6ebd"
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