class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-7.1.1.tar.gz"
  mirror "https://ghfast.top/https://github.com/hashcat/hashcat/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "1cdf6db3058088d7e3883f63519b5d345dbda0184ec8e1e1cb984e1255e297f0"
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
    sha256 arm64_sequoia: "a43ac3ff59dd43aeb5d1f7bd48ac6e92be6a31861dc2aedbc6a548062eecb99a"
    sha256 arm64_sonoma:  "c43c37dc2e90cd13f6f34a14e410bfe4fd92a8122668c988235b73e5beb325de"
    sha256 arm64_ventura: "d8ed5aae05c1bcc38376379e10c94dbe585c17ec0f0e41e67cc2e1243c6ee11f"
    sha256 sonoma:        "89f867202c4a242568591f64de6871d9029fb89cc2f77d9c48d5fd0c6562bae9"
    sha256 ventura:       "62e57bdbbc58116caacb458dc1be1117cd5d54cd33421f327cf0bed0f2063f99"
    sha256 arm64_linux:   "e748781b7fbdc7620f064f4536e71a552dc766ae75320057d48ac75786e247ea"
    sha256 x86_64_linux:  "32f8ffff6650a6963a1e0ea6855a86a8821ccdf1a229827015d47a533ba317ef"
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