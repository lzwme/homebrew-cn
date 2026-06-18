class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.6.tar.gz"
  sha256 "4ed4ac29d5eba4673ea18dba943dd3192c896d1c46b07fe97069c21d5e0e53e3"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2822dc375eac9f095cdc0fa7e32040d1ea9c28ea84865bfda4a9956aea859e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6d8f3ce5ad4cc26dafb58a4fc39e3e3b0de7d7a876f6b2e221a938f91777f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6bcca2046466766fc1cfab7b9bbd561c458f3342712a6221d1ccdd372e868d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e91958974f7d6771883823e6040c5b08cac1fc9c3edaa8e9b4337f5df115ee64"
    sha256 cellar: :any,                 arm64_linux:   "f4692d1173bcb015be8357db204531e289a3b2326bc233d4f6b8d6baf8ac2305"
    sha256 cellar: :any,                 x86_64_linux:  "c2e134246948adce2fbcb163f13e05d7f2523d923d6636b5a8d5ac58508c199b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end