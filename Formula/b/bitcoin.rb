class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-30.0/bitcoin-30.0.tar.gz"
  sha256 "9b472a4d51dfed9aa9d0ded2cb8c7bcb9267f8439a23a98f36eb509c1a5e6974"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/crc32c, src/leveldb
    "BSL-1.0", # src/tinyformat.h
  ]
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cbbb663003fe06195bcfbd38fc39b4871d25a6860f8dce9862d1f6999f615e4"
    sha256 cellar: :any,                 arm64_sequoia: "1129e1fb0f2987790d5918f091511d6b9f8cf10a9c2176883224bb74980f0aad"
    sha256 cellar: :any,                 arm64_sonoma:  "a4686325aad304bf3ff7f4ff15a3247f41a94ad08e69d297f9b9cfa5c6e8cddf"
    sha256 cellar: :any,                 sonoma:        "63b063364472fa378c8eb99c5fc6626540a0c0ccc52c63108abcccd1862d6d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5999e3be7485159f9de4c3acdb136474d25d61767e327efdc70a088fdd4bc557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b2a420c36860cef86f8629053d06dd3aac750cc4ced5acfcd7b1615df79e84"
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