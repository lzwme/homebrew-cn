class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.28.0.tar.gz"
  sha256 "ff0ca443b94be71a6668810dc7c96e1535e50198978d5d84c48b1c680b0c1895"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2640a2e3b55c4f1e6614f8e3f752e3a7182111bf66be691dfd73faca52a3a7a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6d1926f960f819bf63f06c2464d98b5a6d58c05932f327f0fdef9c84278d70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9d5ddd8c57b6c46a7c83a13f123506b013703774c69b27370de80f9609eef45"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a97d170e9ea5499b5cc75ee661b9c5852cf0be316abf8f6e834f1ea0b10d376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "459ef4cb09f31d94ee6f56817f1e6688796740f0f384e7b665cd31230e286043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b6fbfd6f1ad11a37ef340a20e5babda9ffec21b1bee986121a3382e02f732c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end