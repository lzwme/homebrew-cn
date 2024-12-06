class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.16.tar.gz"
  sha256 "b30a2157cb72d91880789721e9c098f00fd5f4414ff50c648158cbdc8acfaacb"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "8ceadfd65db37ece55094036088bfec176840290018feff93ca5ffbd4355b0fe"
    sha256                               arm64_sonoma:  "1a7eb94e8d7bdcafb5e4b005b25ad2ed8af27b326d123f23025a201ece23a4de"
    sha256                               arm64_ventura: "8d90db2d6011b1952122d60bb60a3a914469758e9e93a2c5034b1e6daa5d219f"
    sha256                               sonoma:        "a910ece6082f7fb5e334240d8ab7a0b29efad34bf23668f956b6acf655f483c2"
    sha256                               ventura:       "9f0b74253fd0fd6a91b29469d70f399716792f6b880f26a057f811c56e7fee65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c31d6c6f019decb35e00e9233243c4da91fe1ddf7deb19be5335e0d3ac18db9"
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