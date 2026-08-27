class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.31.3.tar.gz"
  sha256 "b3ed51f2a5e5d088f33bb793f384e8a03928b3a631f2c0460c0a81a95016abfe"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ff0982dfbc0d1f62e74dc2830391e8bf882b70ea3e735e03bf3d7077abd35cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54be87cfb75c24dbf51773c60251ce8936f1dae65dc9ad1bd7e098d0ef4dd076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c8c25eb59bcdb6e2468e8ce7a7aa5f586925cb5643ec01a99d6d533a3fa4b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb10d09a27e58c6201874da388ff932c51f9cf231740742583022cae8b76826"
    sha256 cellar: :any,                 arm64_linux:   "a8394654ff2fe8bad64a449daf24374eb9b2028c415675b7041eef783b6fb3d7"
    sha256 cellar: :any,                 x86_64_linux:  "472fd95d43f5f2df37dda994d45a38da71d2540e49810ff44496abcfc7ca0e06"
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