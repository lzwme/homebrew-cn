class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "daa72b36788fe0f36495434f519d2d66e48f9c6842e2c9bd5c17c1f83e556152"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1bc50faa75e7458bc5d2fd86f70fee9a3c41a6461d842f55dad7317e59b8145c"
    sha256 cellar: :any, arm64_sequoia: "a68d0f3bea053be859a498e9375cbda6e5c909369d1727948b65c23afb651c4d"
    sha256 cellar: :any, arm64_sonoma:  "a221996f2a8ff134ed7e57605c373678e6c6724ae78e6104c8f69fc5f91563ba"
    sha256 cellar: :any, arm64_linux:   "c139e1d072a5366cdffe21ab9a50698d94ef50c06a66b9f1b6739683e34fcf3b"
    sha256 cellar: :any, x86_64_linux:  "d8e65fd0cb0606a311d9e93152f53bae1ee83f4b7c20b1256df024d21ff4b488"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")
    system "cargo", "install", *std_cargo_args(path: "crates/oxen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end