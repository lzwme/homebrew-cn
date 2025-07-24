class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://ghfast.top/https://github.com/lando/core/archive/refs/tags/v3.25.3.tar.gz"
  sha256 "63de05a1ba1b7eeb93396b8fd343ae2bfb5c83141a5c1dedc08abb4022e23675"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "dca994a5900c55f2cd8700dbcc841b7757892603c986818d2799e31f7449319b"
    sha256                               arm64_sonoma:  "eb6b24bbb68130d563a3c1c3081ed4ad4b28e05435f030a3d1a90e0f062c80a0"
    sha256                               arm64_ventura: "fdf7fce52cb5a623c9ee4ee3eace9781556f38a3b75c911225f03997e90536a1"
    sha256                               sonoma:        "a259d6c4772088eb2838c64a40ab2d26aeef0cdbfce33eedad5b07d02a31b219"
    sha256                               ventura:       "87b9abb2295ce83977ca950eaff7b46339022679704a96067e76707d6e762648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5202e6605ef2991cc6b2580e6b0f7391d3c026597ba0ee7bd03152793e452c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5202e6605ef2991cc6b2580e6b0f7391d3c026597ba0ee7bd03152793e452c6"
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