class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.23.1.tar.gz"
  sha256 "e523bfc9b7ca460cc63e93eee479da062b0fdffbee6fc9629abbae964578d429"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7e407b62c4ef80db7d7e3ebb13df4fc038941fe0fb94148f8d016d48f936d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7e407b62c4ef80db7d7e3ebb13df4fc038941fe0fb94148f8d016d48f936d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da7e407b62c4ef80db7d7e3ebb13df4fc038941fe0fb94148f8d016d48f936d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb0a151005ef51ebb85fc9399bec9707cfde1b42a1e3b3a5b8534ee2663d67b"
    sha256 cellar: :any_skip_relocation, ventura:       "9fb0a151005ef51ebb85fc9399bec9707cfde1b42a1e3b3a5b8534ee2663d67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7e407b62c4ef80db7d7e3ebb13df4fc038941fe0fb94148f8d016d48f936d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin*")
    bin.env_script_all_files libexec"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}lando config --path proxyIp")
  end
end