class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.8.tar.gz"
  sha256 "7e54208ac5fa97f3dc3fc2a5d30d5b5b743c8bec9e17ca9460d2e9ebc89278d5"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b67174f22a990af757c606117253f9c8086c9416407775eb85aaebbf9a0e74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9ec8ccdee6e823de0c7ea369b7438a75156c9f8f1ad7344a7b89ac2c5ac733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f613badb739883ae56c9ccd3bd745964e6e30324b32c69e956c52940be91c9e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fc2016dc9f700a3213347fc897811528e9b9986bb9200b6bf4012049fe7e81"
    sha256 cellar: :any,                 arm64_linux:   "cbcacadf0acd137cbf8f000ac589c47a37dee5946dc0a0216dbb3e85aec0eb41"
    sha256 cellar: :any,                 x86_64_linux:  "aa0f0e802f42fcd86b2a9ee9639b3192ca8b64eaf16b0808376fabfa4d58a739"
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