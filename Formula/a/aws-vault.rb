class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https:github.comByteNessaws-vault"
  url "https:github.comByteNessaws-vaultarchiverefstagsv7.4.0.tar.gz"
  sha256 "595aa99882f4e577fa68f1d45de76e87362cf5b1582782992734ba82afb706e9"
  license "MIT"
  head "https:github.comByteNessaws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e03acfa5e4f2012434737c874c788ba442d23fb30a85489b5843967986eb90a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700fae47551c32bbb3d3c4ccfe2e9fc8900abe8e3c0b7b7c0a9a08c6028bdec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87415e2b25667b5a3c5b6d066ae3720e7283d2c83a1b15aaa9fbf61fb0638924"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3dd34aab4bbd6b83f99d30be16bc5e349b28267f3661cd96cd55614b87c9a5"
    sha256 cellar: :any_skip_relocation, ventura:       "513ed139f51016a6b6d675f20fe5a249dda8888190539554e73c4799c545bffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3f930927fd54a0750067d138bddf1029b336309be66f17cab4ab171f832d19"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

    zsh_completion.install "contribcompletionszshaws-vault.zsh" => "_aws-vault"
    bash_completion.install "contribcompletionsbashaws-vault.bash" => "aws-vault"
    fish_completion.install "contribcompletionsfishaws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: argument 'profile' not provided, nor any AWS env vars found. Try --help",
      shell_output("#{bin}aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}aws-vault --version 2>&1")
  end
end