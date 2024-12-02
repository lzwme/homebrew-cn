class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https:github.comrobertpsoaneducker"
  url "https:github.comrobertpsoaneduckerarchiverefstagsv0.2.0.tar.gz"
  sha256 "a87d660840b61a80414dc7c0f0ff246a9d9cf7f3df0eccde29fbb3665aec25c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb5bc1434b9e3cd6c00927858f9a4156f9d21b913dd6a1f4f99448c9f379979b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d663f15d605e131532c6ba8fdb1b439eae56c4a7235d1cf2848e8475eed4e824"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da56576ed1562cddd392205806454bf1201b148041fc2a928a91f9c4be188516"
    sha256 cellar: :any_skip_relocation, sonoma:        "915dca5cceae0d1e74ba673440029cdf828c8d05054dd1d6776b0ff9955288cb"
    sha256 cellar: :any_skip_relocation, ventura:       "97ee6b0253b361729b9a49156ac2e0841835916523c23d09339b8f9596b2e366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d02e8d98e8663038c4ce66513ce78a95377dc8721c324f6df73f6aea64ae5e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}ducker --version")
  end
end