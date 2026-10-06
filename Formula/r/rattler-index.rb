class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.33.0.tar.gz"
  sha256 "9fc407feb184f5fbad08d2748a931ad221f4655d1ed158c6b28ce1c924817e87"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbea8fc22f1cc57836fd45e1e31b5eb099c611246fa1162de1e5a91a41016f4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "953929936f69ea6bdad13f961bafa24bcc88d86cbea2a4fa41adcf318ad104b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8622830b00e692cdd4ee7e754ce2fdf380470313d454d9443fb46a7e4cd3c40"
    sha256 cellar: :any,                 arm64_linux:       "564514e5a6fadb2d8fb5418507a396ae19f506dd41a7fc7b81aaadf43d408cb5"
    sha256 cellar: :any,                 x86_64_linux:      "961abfdfb4063158f102c80a336ca15f76b36d71ea7223890e25c0f36f9f9a25"
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