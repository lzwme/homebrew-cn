class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.19.tar.gz"
  sha256 "894abfda4bbff4afe8a3193094f8d7fadb49eac4ea0d971e16ea9f0601b23dbb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cda7a207c81db1e2212a4cb85bce3d231d7c3a5e40993f7258d38e764aba43e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d55c98537e3cdc6b513326ce765bfb3aebadbd1c3625b9e162d92e4a919a35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf0bafa65311dbda1c6321f2a58700a2605ca6330c7b50c57f1874efd3c89145"
    sha256 cellar: :any_skip_relocation, sonoma:         "566d7030317fc72f96be5ed212c7429cb216b517424e9fcc5ca2951b4c56595a"
    sha256 cellar: :any_skip_relocation, ventura:        "08f7753c5ebc447910cb6de864613ac7a15de687c61dedec81978f24da4eab16"
    sha256 cellar: :any_skip_relocation, monterey:       "3a42565af0253e86f0330c69c54f7ed0e133c8af0111f5e929ebe93eff420d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b17cf960b2711b68d88992c56a1cd5e746344515d0c74eac57b436daa870347"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end