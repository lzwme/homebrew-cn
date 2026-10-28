class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.1.tar.gz"
  sha256 "500f03c80f19e25ccdebe87f23dbaaa1583ea01a10386bb269150f29a2e4b849"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "247d20cdf14f578fd203f9a9a9bea4a6f8d6524245388d19752dedc45764db86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cfb470d6e0474f727d35aac6cfb519d021a66893ac97b6653d850ebdcc44f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c90962c4df4f2b1b77f195bc8181e3f9ed42cae0e2fe4875506f7962bf428a7a"
    sha256 cellar: :any,                 arm64_linux:       "7d7a656ebe7c40aa4d141ed4a45a164d0dcde5788ab4c5a9769cdb89bc6e0a4c"
    sha256 cellar: :any,                 x86_64_linux:      "6634f9e6653e30d534dfd6f3ba92073bd930caf89fb8761026669c3c381738e3"
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