class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.4.tar.gz"
  sha256 "97ca7cb991b181c545ac0d0fa31ba8c5b24ce22106a02865db0fc0be5283b9f6"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b8be2b3a926c2a1bdfd6f1f23745c7e03c10e1078b562b96168168ebb8edaac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5847db88650187e11a7743339c769aed01f60e8b4ee7f154d1f16f2802482282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbcd07ac03f40481dfdf8fc94c133f3483068a8d2074a1e9419346ed17d16f89"
    sha256 cellar: :any,                 arm64_linux:   "8a85bed729ec2a637e2d01f26bac18697cfae439f33deb69aeefefa81c6df740"
    sha256 cellar: :any,                 x86_64_linux:  "c392071a54b0539569ec6f5e453157a6dcb574ca7e784e5a8a661e157759f661"
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