class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.20.tar.gz"
  sha256 "2ef290cd3119736e2cd52527535d48aeef2293c63c383896675592130890d999"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "3a726c7b2c446e455bd046e8601718b95734a994e080d224545175129464083c"
    sha256                               arm64_sonoma:  "0e0df18a7be6cb5b7de32f646c138b753ee8c71ae90e2313fd77567e89237f76"
    sha256                               arm64_ventura: "abb3c538803816ce73e7d41d9710df7bb4ab5c288b7e47c9eecae6285db587df"
    sha256                               sonoma:        "b7d72801a8473c6f43f45ebb187a6ea1bdfae62bcec30a278aa1635f0f295d91"
    sha256                               ventura:       "41c288d3f6a21ec59eea9130179e895d816d9cf510d5752cc0a1ac9515ee7947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9f26c5424bf9d4d2d2c62fefd54e18d7220e9c0f0c7de99c4882a0fd9d4b15"
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