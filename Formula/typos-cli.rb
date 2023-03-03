class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.13.16.tar.gz"
  sha256 "83ce7abc59ec7843361242ccc8627b36a32394164459e1f9e3dfff8fd0588a81"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32be3522b291cb6f7833ca35e1dddc44a8485cbbea2bed2783de22afa3ed1e53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23b319fd28f23e75a82c72c222f42a619e042ac95b8bf6dc752c48458d2e60bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acc73b62f010be5c258046d71304bede6c83b771aeeac65b92f2ff1fe9ad2e5c"
    sha256 cellar: :any_skip_relocation, ventura:        "54e997d84a3be330e45d6f0f79b7071a911baa256e9882324276e594de60123f"
    sha256 cellar: :any_skip_relocation, monterey:       "8b84f3ef949933bdb8e46ea850b4f069bdbaf6d05526c18ffe62d25b1c8da3db"
    sha256 cellar: :any_skip_relocation, big_sur:        "faa1d3b42c045bf7f6926fc2369fa189be2e94478b06d13c41da634926062e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff50faf1f46317dd9c9aced4daddd35f6f5f555065df6b449ea0808e19a0a4f"
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