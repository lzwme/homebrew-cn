class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://ghproxy.com/https://github.com/hashicorp/packer/archive/v1.9.0.tar.gz"
  sha256 "8502b551724d211bff75fbbbf8f2c5bcecfaf4c84caca2f64cda0a6918f0dd3d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb87e13e1bcacd1f0d945b96227bb1dd563694d03fb58bffbe4b8f37abb1be31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d59f1c0a315d7ea5ed7945f4465ea697ab75e58b59d97b573100dc5bab9316b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2fda0220eda15118dcce7640288232f0a6cf783840c6d1979c7389b0d5311ad"
    sha256 cellar: :any_skip_relocation, ventura:        "0229acac8307edda525da7886117455b33bc39af667a1babda3a4bcb395c40d2"
    sha256 cellar: :any_skip_relocation, monterey:       "2f7a20464ff8c8f446108e8b8132fc39f7ab2d1acf750333cb62d411fb467aa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cc527d81a1bf9078b5b1e111b7c0cc6732cf78b28c656cd356c84aa10da83cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef30ec3b9d803d2afa4d2c8936e0a2214ead73a46e1a320d8cb3f42199743f3e"
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