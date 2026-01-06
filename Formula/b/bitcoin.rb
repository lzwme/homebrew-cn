class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-30.1/bitcoin-30.1.tar.gz"
  sha256 "5d5518782c3000f64717ec1b4291e7e609a1f900d9729ee83c982243779c3f43"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/crc32c, src/leveldb
    "BSL-1.0", # src/tinyformat.h
  ]
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6ffcbdd788bcda0475a11a6d1357fe95f9b6f13795e2e92af7deadaf23c2b7e"
    sha256 cellar: :any,                 arm64_sequoia: "789aa9906d7af4c70d33a2ce67b2af8a4748293057cb189e50a9bd1e6809dacc"
    sha256 cellar: :any,                 arm64_sonoma:  "f80cb1015724372f46297ebca8ebcb718bacb8c4ebf6737d51551c827974bb65"
    sha256 cellar: :any,                 sonoma:        "53bd35b86388771303cee989f7f6b728d32da9ea212d6bc8239054035d2b18ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef2398cfdf3456d653f91bd9527f19a3ef3901c34954ab9268ca36d27276733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c41b0d9a6bb969186a3d7ddfc540cfd2190973501959bbb519ee5b2edcad86"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on macos: :sonoma # Needs C++20 features not available on Ventura
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_ventura do
    # For C++20 (Ventura seems to be missing the `source_location` header).
    depends_on "llvm" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++ 20"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.llvm_clang if OS.mac? && MacOS.version == :ventura
    args = %w[
      -DWITH_ZMQ=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system bin/"bitcoin", "test"
  end
end