class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https:github.comByteNessaws-vault"
  url "https:github.comByteNessaws-vaultarchiverefstagsv7.4.1.tar.gz"
  sha256 "7bf3319017ad88da0236b98a4cc2c1489a52d533afb2780569b9555b53672d90"
  license "MIT"
  head "https:github.comByteNessaws-vault.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f5f8774ff803d104fc4e32b763069c5d92fe9afa432016a1067d34f8a85322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfa49e8b1bb3f99fbcd40b1be5eea54ae72b3cb2410aa50e32aed838effe7988"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf74c96b7e9a5db48afb4a548980a9756b6098e0eb9fd45184d1193331d728f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b733c48565a013d562d24b32afd427bfcc9b06e52c7e3b064af15e3a116214e"
    sha256 cellar: :any_skip_relocation, ventura:       "27cb395f8086a07c79f6d476cecd255a1a1f4ff90bb6567207654628f7788b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb7d3643b2f8ec963d89277c9a46742721d9ab8af167e36becd122d217b25ad5"
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