class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https://github.com/hashicorp/packer/pull/12568
  url "https://ghproxy.com/https://github.com/hashicorp/packer/archive/v1.9.2.tar.gz"
  sha256 "16e5aa31892e917c18f866596c8fedd93e8631f72881997f20143bf2d22b91ee"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86078dc8c92b266ec793f3640cf84b78482a48811a8983ca3f0d50af356e571d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb1aba43adc3ea94d7f144f7d4e30ef7772d6286c477ca4ffea276dfacbe4d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2507ed2ee7c00cacc1c1737226953f912d1f7a1b2ed71c358d61532adb349663"
    sha256 cellar: :any_skip_relocation, ventura:        "7b99c7d8b0114cad8f3fa4cbd008e622a806436aafa52df08efba8d493c7a08e"
    sha256 cellar: :any_skip_relocation, monterey:       "75755be6f8513147b70efb3f858e3d5b45189218def98ea7073d79daa3c73f46"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc7bde320467a20c3a01914ed4df5a224d8262184d825d158c805e80bfbe307e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5386bf4d1987b195a6aabcc56e91e1adcd2339a2d4623ef6d7f78e5b1f9a0d24"
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