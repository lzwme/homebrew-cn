class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.4.tar.gz"
  sha256 "e11759683fb72bc402f7e3b5d5cf03315c521fdc8cb21d124542734809f581f2"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95cb6f6f6b96c9efc4562f0dd191e9c20ea396628bfac9625d4919822c78ef29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d456ddb767af8293bf15f5576b68e097e83d3742db0fc35145d30b2254c3b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae1401680139dbb4977de9fbe7f15b0f2d4ce760ec34f55aebcc68a83d7fb45"
    sha256 cellar: :any_skip_relocation, sonoma:        "efb51e05db5da3bd6313f8586cabd100f6135c161f89d0668f047e8cd5c89f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f5ec1b3bb63ed34bd05c59e74e9e563ed87f522183f02f4dd061d6463e1461b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d62a79aaa2b8c7101f3b9717bbc813b5bb9da0ebc409ec84a84566bf59b2c8"
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