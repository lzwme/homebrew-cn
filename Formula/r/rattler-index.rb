class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.9.tar.gz"
  sha256 "17eb2933f581bf914a8278b7083ed8be1520ef67a7c88f75fedec242d5c830d7"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c931ab5224723baaee8a3830e96a62807623e934c13885a2a7269c6c0c7e860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8725bd8e021811635de5e6a3a71409594e17d3f275c2965d5f1a264e962fc91f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f4219950bb5133d844e9a599b190d90fa7e05760a3a2ade3214242071b908c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "485f2cbd730ec2ef973e5d0a3f495ea6e63d19bbe3adca4423633c76d7fe64eb"
    sha256 cellar: :any_skip_relocation, ventura:       "0971fca5767ec2a6caa9bf55661fda0e48d375a563d9ebdc1c98db5ff2725783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3fe05305c136ead0ca268c1a28d616df1bdc21f3636428d00189441dd97f668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9f90718fa79b06051deb0a46c1dc7e945f1fb0181f85b9355af067190f11dde"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end