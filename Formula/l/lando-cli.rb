class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.24.1.tar.gz"
  sha256 "3c01582ccd2f9b0e104ef9ce5105cde3913052788b64ac9b471f2d4a9859451b"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "fa6bfd59747e96af0d71917a22d12eed66637c7313de3803aa80a4b0f6ae990e"
    sha256                               arm64_sonoma:  "cb7cd03cae986777db9ed3805587e86ca31cd828fac7c4265458c7ecd48d37c9"
    sha256                               arm64_ventura: "6284e612f1ca5940122a555f11671f27f904c2dc03e2bafe1410efe9555dd935"
    sha256                               sonoma:        "dcde16e9c342fc1d438a17ccd8862717fd06d8fe0966f9ae6b4839599ffabae5"
    sha256                               ventura:       "926f53af4b9ab4ed2eaaac30f972159c702d5da35216b8d44579542290da85c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e95c33c4fe877e07eb1897339a612d2619f14d2e183960a68fcaac71bbd0bca"
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