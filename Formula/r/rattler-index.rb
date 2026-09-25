class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.7.tar.gz"
  sha256 "bd1733e7ffc5904aca0e33322cd6bf27b431fd593e1eb1d3eaa2f1e3bd986718"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e9faf298a88084acbf6426cfc0aa22733d18271d78dcadc82be6c00096a90c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be3f8ad001783fa99881bcbbfceab973428238ffd0347ed4345854836eb0195a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca4cc9dcfa1e5602a53aa9046ee3c0ffa478ebbd6c04ece8c9bcd65e4cfc51f2"
    sha256 cellar: :any,                 arm64_linux:       "8557602283784e37b5dfa1765d93adbd1afb938f9575d3d8dfe332a00a20a60c"
    sha256 cellar: :any,                 x86_64_linux:      "b4378246b9c6072ac926e3860fa7ac59ee9d44671cad5ce13db7bc8a213ba316"
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