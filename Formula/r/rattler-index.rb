class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.1.tar.gz"
  sha256 "321483f684920d838da9b55ebe7eef38a8e543299ea746a1e60097fa5a0b1c87"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a7b2e914bd5b901336e08c5ca0cd3223faae3cf00f906842e024105751a3a02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c7c828f4a0f714919a468a03384000d455dc94868111293584c6ed3d01cecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4ee6ce63b66fb1bd71eca2ff9877e7f6942742589abb340b3c7b344f159cb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "52e1cfcc8ea1ded01904c9d4ffa6a5b014002dd0ecb64d0a4a1787f292a8e7f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b0903d7640f56217a0c66f036c4626b6b7bf6a29c79cee9e97f57507a62dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7be8d2c4074f753d160eaa5ba407327bb7d1ba61948229004b73ae3e4de985"
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