class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.22.tar.gz"
  sha256 "3dfc6f661e39e9f29ebfab297a7da1ebcaaff08e41fb64c441c177452cda9f0c"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "372797a5f712405a2537706ad732fe59e90d3cf48ca042fa38858b93025ca360"
    sha256                               arm64_sonoma:  "46c2775f1c650961fe26e390eff3f2f2d659fdae87429791213f881f108a6c61"
    sha256                               arm64_ventura: "96138e5a9dacee26e832d1e189004300fb4b7a7fd24339831a2c79ef0711ff79"
    sha256                               sonoma:        "f27ded57f45a01a63be74e9a1d14b9432f4d9612c615f40e9f449c066ca3df99"
    sha256                               ventura:       "5f03ba9174104d5fa80efcc8d4774cd52d8f1f654b6c4fa61c445f38adeb2cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73068254972a77d94353e8176946bc6271bd916676a187374499c1244d8044f"
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