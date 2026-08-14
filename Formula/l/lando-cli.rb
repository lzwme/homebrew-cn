class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://ghfast.top/https://github.com/lando/core/archive/refs/tags/v3.26.8.tar.gz"
  sha256 "3ea7993d42c747c174823df6b89404c6d1e2a0dd1bc7864ad13a2aaa025b5c2b"
  license "MIT"
  revision 1
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80742158d267937efa38dc1393d4442c8dde907a52592b21fdc7365a228186e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80742158d267937efa38dc1393d4442c8dde907a52592b21fdc7365a228186e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80742158d267937efa38dc1393d4442c8dde907a52592b21fdc7365a228186e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "80742158d267937efa38dc1393d4442c8dde907a52592b21fdc7365a228186e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b01685c496c00a10738be019d776da87bcdf637e080c915109f4ae14636d5899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01685c496c00a10738be019d776da87bcdf637e080c915109f4ae14636d5899"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}/lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}/lando config --path proxyIp")
  end
end