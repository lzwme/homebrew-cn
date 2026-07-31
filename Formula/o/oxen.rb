class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.6.tar.gz"
  sha256 "d750dbd1581f84d3fb4903b08534938ccdc3bc9d5f90b2a3ff73b6773496f459"
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
    sha256 cellar: :any, arm64_tahoe:   "eb2d995a630ac44add712545b8be802b02dda82e98861d8fa45fa21b3ca8189b"
    sha256 cellar: :any, arm64_sequoia: "25b825ced179fd44f259f86be96af7399e88b7da63a252a34654dc0db2aa9cf3"
    sha256 cellar: :any, arm64_sonoma:  "a7746b3ce3ab289d01d81acba425f40d73766f580f3d5a156fcb46956bba8963"
    sha256 cellar: :any, sonoma:        "cf00f45d16719f3cb6b6f43c4822ab28e47b88890a358406448fdcf077f53584"
    sha256 cellar: :any, arm64_linux:   "b47a684586decf6a3b4ddc4673bd0e43f181f8c0ae5a4f7a21d2ec4a2dd84432"
    sha256 cellar: :any, x86_64_linux:  "0387d2f6c1a5db7792e9d18f840ce88b6faad341f44b9368bd6d2a0dab0ec1de"
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