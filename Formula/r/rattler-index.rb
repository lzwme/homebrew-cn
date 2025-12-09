class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.7.tar.gz"
  sha256 "7712eddbf5bcfa0e3068aa88d39722c85823538ab0472f6c1807066bc8203c0a"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc32084392f4c25fde654519d7f3956c3002613a061bb0e5182aea2655e2961a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5679a0fe8b91d4c65725283d6a05b1e0b129b21a8a3f429efa5678b7fcc74114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377524ba7b5958dc2b3d9e0376ec1c13736dc7a69d85a01c8d4bf26e120f29ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "92434f9eeb6f5d58e928612123e207d8823291478e05f112908ce603650bda72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e592fc1989c32ba62e0ee7b86adcbb404e89ab8e9d37e63fb96c0a5deb4ffa39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03335cb4dc14a8d2c6e03b744c6808a5352d09630ce190dd6ddb8d430066e72e"
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