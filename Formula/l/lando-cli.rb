class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.12.tar.gz"
  sha256 "db642f92f610f03ea7405b7f598133c93edc23d274375810882e4d7a157bfadd"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "ebf7074200953d6f24092a385331ff36505ae7a26bd8d17e1d543d37c3df41f7"
    sha256                               arm64_sonoma:  "11723421a5adb3972b90781829fc24f24a749cd31b6783bbdff7937827d6714d"
    sha256                               arm64_ventura: "0975b1dc6fc9c31a686770f4589d990d09768c99e641536407518b22d69486f0"
    sha256                               sonoma:        "10c72ad23708cdbe8a2dbac19355ea8c3e578de93b4e5479e5c1abb40debe8d5"
    sha256                               ventura:       "97c483605de952692f8fc81d22cbf63a02ff68bb0a6d34294b33e2f506215626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3166d58a7630ee5009f4f746df0a6c4d0213fd8fd0dd68e7b93c7ae1232e75ca"
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