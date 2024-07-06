class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https:github.comvultrvultr-cli"
  url "https:github.comvultrvultr-cliarchiverefstagsv3.3.0.tar.gz"
  sha256 "801102036a0ca5153a72281d67fa8070311ea893c25ddc8f38d25475b2e99989"
  license "Apache-2.0"
  head "https:github.comvultrvultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fafdc9d13ca372f61f7ff597fc2c8f9dfd8eff66cc7bb2690d5d5e4390c41063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc7401f1b539bffcae52da543b6a236416ea9fcab94680fd3e15a5d7281d8a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4efeee655d9201569d9b91f6d5370a9140c61d37af2e1bcf8a07418d644e6b6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "453f4bb3ce8f84a61eec672e26bc8d76d504342cc2fe411ea1afac7798c1e3e2"
    sha256 cellar: :any_skip_relocation, ventura:        "1cc6e273c9a9ca3b157c4101a04fe09d54adb51f6d60fee94cd43d4c4ef56c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "117632522bbbaa25c4de8e6845e4e71f7b025440005ad8a5abf44be9b5fa592e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238ec2ebebdd854df3f49ac11fdc473c99ce8e5cea3fd8be6f5ab1e7d38b0d1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"vultr", "version"
  end
end