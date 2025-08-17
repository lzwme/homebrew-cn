class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-7.1.0.tar.gz"
  mirror "https://ghfast.top/https://github.com/hashcat/hashcat/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "cf2d73d36b85dfc5a36d20bf2d7516858173d5ef780df2055bc926c6f902da77"
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
    sha256 arm64_sequoia: "bb1809d0a163c5d2c2b8d4158a7604f538ae5db8ed551628929f7e73a0e595a5"
    sha256 arm64_sonoma:  "685c71ea555951002fa5750a8c7122c48be0d12d612bc64dbd266737f0f98e9a"
    sha256 arm64_ventura: "28777b7980f2d0710070ec3a5317a86e8e256fe0657bcd47452a16c48b63ea8a"
    sha256 sonoma:        "939040b2f32a06e164bbc7401adbf961b0223f9a1008fc6a2df406e42ccfcbe7"
    sha256 ventura:       "ce66a96fecc940698937e7e27ea270ba05ed1cce9b3b9c8e5b93dc429565ecdf"
    sha256 arm64_linux:   "791fe33286a1cc4c52ad2c56316a1b36a7a48131531579ddd12a9d01b820d8fe"
    sha256 x86_64_linux:  "2c31d366a3317871e8daa25aca67b9bf3b87143ec5465710d0278a23aa265611"
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