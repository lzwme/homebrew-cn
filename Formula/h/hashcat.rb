class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-7.0.0.tar.gz"
  mirror "https://ghfast.top/https://github.com/hashcat/hashcat/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "842b71d0d34b02000588247aae9fec9a0fc13277f2cd3a6a4925b0f09b33bf75"
  license all_of: [
    "MIT",
    "LZMA-SDK-9.22", # deps/LZMA-SDK/
    :public_domain,  # include/sort_r.h
  ]
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "60e0d322081071c0d4f97b622665bd20389755695ec16fb18aa59c7c8cb273fe"
    sha256 arm64_sonoma:  "7eb8b6d5dc3f307fc09ce3e64fdb8084e82ef78ed5b0b3cc32f00a41931766d7"
    sha256 arm64_ventura: "09d73b4fd7b08e16269bc60a405405bfc3c1393343af7db4120faaa35cf581a0"
    sha256 sonoma:        "cff74ec28e14a6f6948b8e4f787851206fc5c04ee1e9722fcd6dd1bdd3e5e725"
    sha256 ventura:       "f81a32862272387f95735e97606cea6e12dc2f801e36102c93c25af6025a0535"
    sha256 arm64_linux:   "60f62823d4b2a64f7a7ee1b3fca002451c9b19f536e5c9b5b9cfd99883cbd8f6"
    sha256 x86_64_linux:  "c7d149e6673f5cf2945078fe861699c1fd18e74545fa7fa64f78fb8a51e620d1"
  end

  depends_on "python@3.13" => :build
  depends_on macos: :high_sierra # Metal implementation requirement
  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Add missing shebangs to the scripts in `bin` directory
  # https://github.com/hashcat/hashcat/pull/4401
  patch do
    url "https://github.com/hashcat/hashcat/commit/13a7eaabf8c65eecaf18659a2eefd83d36f9186d.patch?full_index=1"
    sha256 "ad7258e835198c66d793c1b28715e6e637ab52cfa2e0b9e4c400c1cdd479e85d"
  end

  def install
    # Remove some bundled dependencies that are not needed
    (buildpath/"deps").each_child do |dep|
      rm_r(dep) if %w[OpenCL-Headers unrar xxHash zlib].include?(dep.basename.to_s)
    end
    (buildpath/"docs/license_libs").each_child do |dep|
      rm(dep) unless %w[SSE2NEON LZMA].any? { |dep_name| dep.basename.to_s.start_with?(dep_name) }
    end

    args = %W[
      CC=#{ENV.cc}
      COMPTIME=#{ENV["SOURCE_DATE_EPOCH"]}
      PREFIX=#{prefix}
      USE_SYSTEM_XXHASH=1
      USE_SYSTEM_OPENCL=1
      USE_SYSTEM_ZLIB=1
      ENABLE_UNRAR=0
    ]
    system "make", *args
    system "make", "install", *args
    bin.install "hashcat" => "hashcat_bin"
    (bin/"hashcat").write_env_script bin/"hashcat_bin", XDG_DATA_HOME: share
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"hashcat"

    # OpenCL is not supported on virtualized arm64 macOS
    no_opencl = OS.mac? && Hardware::CPU.arm?
    no_metal = !OS.mac?

    args = %w[
      --benchmark
      --hash-type=0
      --workload-profile=2
    ]
    args << (no_opencl ? "--backend-ignore-opencl" : "--opencl-device-types=1,2")

    if no_opencl && no_metal
      assert_match "No devices found/left", shell_output("#{bin}/hashcat_bin #{args.join(" ")} 2>&1", 255)
    else
      assert_match "Hash-Mode 0 (MD5)", shell_output("#{bin}/hashcat_bin #{args.join(" ")}")
    end

    assert_equal "v#{version}", shell_output("#{bin}/hashcat_bin --version").chomp
  end
end