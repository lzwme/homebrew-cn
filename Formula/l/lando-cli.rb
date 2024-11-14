class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocorearchiverefstagsv3.23.7.tar.gz"
  sha256 "baa02fe1733c6d76a6ba42c058dba9b308e1246378994b7441d18b5833815d8c"
  license "GPL-3.0-or-later"
  head "https:github.comlandocore.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "1886da7f0dfbba801f2d1c44dc50e100cf5907ac5d184d0fda4a90f381f05b62"
    sha256                               arm64_sonoma:  "57f955383a45af74d96bb7f2d60a25df4f0e5ea3b182ce14f05e07f116a93f44"
    sha256                               arm64_ventura: "b1b35a50cd87075e1d040792f12e011ad2f41bb3a2df35293e7614f230b5dd87"
    sha256                               sonoma:        "cd0f227c21dd214eb55f40f725ca2db73762ef2ef4dd489687387e87fba4d349"
    sha256                               ventura:       "684af73247b50e9b4280fafc551007badad5173333c9a02edd48e97387ae769a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c1a18e40beac6462b86349785045f99ddbe47a27fff639923f937968684c49"
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