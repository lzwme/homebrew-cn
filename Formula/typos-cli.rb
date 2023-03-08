class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.13.18.tar.gz"
  sha256 "51eb1cb1481c117561844dfb4950c9e419f68e713111d4bfb4a787f917376f94"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c0cdef9062e8cfd398316b65461eed0d3966f2bc3851c21aaeddcdcebf0750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba7b6558f0409c1563e8098d811d3e590b64e35e6039f3033657335de0346a6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "460e1e8785a9df282472b35d1fe04518c6dcee5ce5f90f1b3bafffdcffd0fe4c"
    sha256 cellar: :any_skip_relocation, ventura:        "0801d509443a75b7f4e187bdc846f59a53e2ff601f0eacea363830f1a25b7184"
    sha256 cellar: :any_skip_relocation, monterey:       "d64487907dff2a68b7cc8ae935974a1f0e0d0489656c5bb9a843ac339d7707e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9352c6c38adb4f35170a322c71952dcdd9dd0181dfbe9ee8a384ec8715805599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e2abca73c9e5e2b8bc326d498c1698965495162bbf5dfbe71205f0d54b33ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end