class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.22.0.tar.gz"
  sha256 "8355d7ad03df96bd265e65c471f7bafd46378e52f74e88cca3934d88ea5706bf"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af7093c2ab609ba2f29d1fe1966416da675d245d6368684e9d74b9df817ec1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4af7093c2ab609ba2f29d1fe1966416da675d245d6368684e9d74b9df817ec1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4af7093c2ab609ba2f29d1fe1966416da675d245d6368684e9d74b9df817ec1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "31cd1e46e4b533fa5fb3598224e0bf2a316c614aea7153d5288d65ac44907b1d"
    sha256 cellar: :any_skip_relocation, ventura:       "31cd1e46e4b533fa5fb3598224e0bf2a316c614aea7153d5288d65ac44907b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af7093c2ab609ba2f29d1fe1966416da675d245d6368684e9d74b9df817ec1f"
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