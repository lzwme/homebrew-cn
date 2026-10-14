class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.33.4.tar.gz"
  sha256 "f7642c2a4e3a626388a97ebc5a5611211fe5a9d76f46c753acf6a2f13cc7ed43"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6a1d5e1d16ad04d84639e68188df26b970ceaadc518873d0213cbf86bb3c52b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6206672001c21cafe25d9ee00c4baf659f0f793f3a061347dd092ac086800fd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85a58303ffc3eb396731d99a4276b7ed3f47adde7a8ed828d4363e555ab05d93"
    sha256 cellar: :any,                 arm64_linux:       "5abf0084468e0df98e53b354da8960068b6ebb8419b03563ea6ec18c2d05a6d7"
    sha256 cellar: :any,                 x86_64_linux:      "999735ccbdda8b642837bc8da8848b5c7ea55dec8f959e6842553a49f6b0692e"
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