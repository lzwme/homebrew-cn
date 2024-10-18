class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https:docs.lando.devcli"
  url "https:github.comlandocliarchiverefstagsv3.22.2.tar.gz"
  sha256 "657fadd802194959b7ffe5c21ede9e62a1f506d435ef2f834a076621302975fd"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272f129126b0426e56d976dad866e7163d64eb5c00d6cae476db14a39e72197a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272f129126b0426e56d976dad866e7163d64eb5c00d6cae476db14a39e72197a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "272f129126b0426e56d976dad866e7163d64eb5c00d6cae476db14a39e72197a"
    sha256 cellar: :any_skip_relocation, sonoma:        "601e9f4810153c967c773d7f0ee0f1e8c008ccc677b0ef6a4ab5061c3ffa6ed2"
    sha256 cellar: :any_skip_relocation, ventura:       "601e9f4810153c967c773d7f0ee0f1e8c008ccc677b0ef6a4ab5061c3ffa6ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272f129126b0426e56d976dad866e7163d64eb5c00d6cae476db14a39e72197a"
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