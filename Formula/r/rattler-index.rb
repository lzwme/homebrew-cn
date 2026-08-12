class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.0.tar.gz"
  sha256 "5af06d44ede489a2a64513128cd04f569ab0305d6da0ecf2625f7fd7b70b0ea8"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67e98cb145dd3011f85fe9bd8dde817e291268b9a329df16afa446f9a1fcb571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f2c3631cb420ca5f953983e7f7f276516510db4aa6b2521cc96f6bd5fbcca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00cdd20ded0cb250c6610bdf92a85e51e4771313265928704699726877b06b55"
    sha256 cellar: :any_skip_relocation, sonoma:        "7efb543072e347c0341375f0033e6f39feefe1562d9cfc69a6e5bed7bfcd964c"
    sha256 cellar: :any,                 arm64_linux:   "a0e6fea2535be77388f9ff8a987875bc98791590b7a6300736ab40b7ab5bfe26"
    sha256 cellar: :any,                 x86_64_linux:  "0c1c84d859622ed2757636d84ee2cd98730a778259fe2f1d26b99128b98d4d43"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end