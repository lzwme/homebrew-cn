class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.1.tar.gz"
  sha256 "8199bc8ae0683fe8d8e32345090c61c201c2f174baebac9517c29fc3facbdf58"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cefa4e612c2e829981a9b6401a7dd2c70347c55817df883b0a5cc219790e4ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b701f641abcaffafefc278d59064edc4400dba324066cad757eea22bf770a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fce1720ce8b22bea2bb00e88708a7fcb1d2d3afd1d11002c2699a62ede9e0ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "aad042c14543aa921548fbac5173742a59f280c5a3e25d802f18561401f8ac79"
    sha256 cellar: :any,                 arm64_linux:   "e52d9574e93cbc67038506959daf855e52d7753795f3de939bc220f08d5ffae5"
    sha256 cellar: :any,                 x86_64_linux:  "9880d24e1535b1f4bc722ef616411677a875b3d14b4c326e9795f3d31278e96a"
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