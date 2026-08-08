class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "a9c70c8ce30da1a8913e0688d5da394147c59c5c861c9343e5a250069155df2d"
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
    sha256 cellar: :any, arm64_tahoe:   "372d4c2fcbab574127ed71b42c4fcaee6450032139f6320ed835bb6231675b4a"
    sha256 cellar: :any, arm64_sequoia: "3d6bd5e56a918ac22b773344f01d29f7c21e839c17c5abf8ec8fc8a255381f16"
    sha256 cellar: :any, arm64_sonoma:  "aeb7cb902a8ab565bddea14bb9c418685cf0918d93120845bd5de74f65e11825"
    sha256 cellar: :any, sonoma:        "64413c7d34e1bc66f3187b9618f9e320c823544f05d0f525d4d864a95ebfd3a1"
    sha256 cellar: :any, arm64_linux:   "273de850b2ae2487275bc26f2e3c105989f4919f4c44e92ff582247b1815a568"
    sha256 cellar: :any, x86_64_linux:  "aee383ad063e8cf4c2b05a68149dfa99eaaaca5dfe0b316aa81b9aadc6faaeae"
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