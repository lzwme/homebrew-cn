class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.33.1.tar.gz"
  sha256 "daeb3ce8875929209231261e5f1263638550466f507141920b94ca7f1f7d63c2"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b355c95baf8a151cdcc6fc1114741a58fa38f838524787463a686d9639eaf5bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "792e7e94e51a16edd61003166c0879ead085128057b63d54a2c608d5c7fd100d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5a6c3adb553008abe52c8f033e4978223b821b4032a1edf8b96c019675a2ced"
    sha256 cellar: :any,                 arm64_linux:       "5e116e95c8db7f64f4cbfe93ea7bcc480c00745834420094e94cf9a854eab1d6"
    sha256 cellar: :any,                 x86_64_linux:      "60d790ca032ed6a658a4b97ceb7662548b06d9c93e5726e6ad1c32c68dc6285d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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