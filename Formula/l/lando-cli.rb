class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.19.tar.gz"
  sha256 "f073b8005e38413f09cc225721ddef68f1c16f0287b05c9424e747392a5e854c"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "1e9d221d36549cbab1c101e4271cd6eb7ce9fe74acf8284b9079976c75b980d0"
    sha256                               arm64_sonoma:  "2ea364463ff0ed9e507ff7598cfadf43323b7092f9df3fb7c47a015fe2048652"
    sha256                               arm64_ventura: "a972f2fe79e3909acb9fa18a3bf61d07663dda1814b0287da0404cb0392cfbfd"
    sha256                               sonoma:        "9edfdb0bcd1046e32b26f0a7ba81bc7e5678b4e8765daacbd23d46ca398c9254"
    sha256                               ventura:       "4d694b9ae3473d929c4bf1c3265a5389f60a55bb07199f2c9ed66d69e82555c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4126681c37237fdc3ff008c2febee638d886dce0078b4323019da7d17c9eac09"
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