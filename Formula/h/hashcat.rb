class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-7.1.2.tar.gz"
  mirror "https://ghfast.top/https://github.com/hashcat/hashcat/archive/refs/tags/v7.1.2.tar.gz"
  sha256 "9546a6326d747530b44fcc079babad40304a87f32d3c9080016d58b39cfc8b96"
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
    sha256 arm64_sequoia: "6807408d8e4eb4e901f14c1baa48334bb844f7aff7fcea4c6ba00db50080cb07"
    sha256 arm64_sonoma:  "b8dcac2e345c3b68845b90313d6e0d6f022a242c315aad9b1a52552ca379c900"
    sha256 arm64_ventura: "f9659f72bd628b84ddc68f053aacc71303c7093e1c3838870c8ad6fb85d02fdb"
    sha256 sonoma:        "9ef21965d41379bdb82c91ca38d04cf7c48e4e7e2ff4dda8f3a93e1464e109ab"
    sha256 ventura:       "5fca6952bd7d468f9a5e3d9b2754fb00f5e522aa4b183cc90c157568ca00e40b"
    sha256 arm64_linux:   "8d63b4b3b974815f6e9de2e9c833e2e747d64e90302e418a9476b84043e8ef03"
    sha256 x86_64_linux:  "f5390dd3106e338eccd2fdd513fab9533adc2c7da17ddfcaf2b42758eb3579fc"
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