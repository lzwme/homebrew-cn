class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.4.29/buildbox-1.4.29.tar.gz"
  sha256 "d8bfc8bdbee4a1cc5013d691c4f151be6399c5db3bf15b98dd85cafee55f985b"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "d85b6d24ea35dc15ac5d861ed0e547c749add49e0b066620e0795b4e685195d9"
    sha256 arm64_tahoe:       "806b216c1671617b984c291843028848ca18232885991a64904b8457d1e3627c"
    sha256 arm64_sequoia:     "b011fe3b8b1ac1c86b8ab5ee66869ab401cec380bdb27657687f949246be85e1"
    sha256 arm64_linux:       "6603175192ff2aa9445c672d9522a4f2a93887642bdd09e9577c669fa7885c9c"
    sha256 x86_64_linux:      "694319761b2ae7d21e9b6e021f64e75461dac7788dde9cb7424932c2c92b4722"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "grpc"
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "curl"

  on_macos do
    depends_on macos: :sonoma # Needs C++20 features not in Ventura
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    buildbox_cmake_args = %W[
      -DCASD=ON
      -DCASD_BUILD_BENCHMARK=OFF
      -DCASDOWNLOAD=OFF
      -DCASUPLOAD=OFF
      -DFUSE=OFF
      -DLOGSTREAMRECEIVER=OFF
      -DLOGSTREAMTAIL=OFF
      -DOUTPUTSTREAMER=OFF
      -DRECC=ON
      -DREXPLORER=OFF
      -DRUMBA=OFF
      -DRUN_BUBBLEWRAP=OFF
      -DRUN_HOSTTOOLS=ON
      -DRUN_OCI=OFF
      -DRUN_USERCHROOT=OFF
      -DTREXE=OFF
      -DWORKER=OFF
      -DRECC_CONFIG_PREFIX_DIR=#{etc}
    ]
    system "cmake", "-S", ".", "-B", "build", *buildbox_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    makefile_args = %W[
      RECC=#{opt_bin}/recc
      RECC_CONFIG_PREFIX=#{etc}
      RECC_SERVER=unix://#{var}/recc/casd/casd.sock
      RECC_INSTANCE=recc-server
      RECC_REMOTE_PLATFORM_ISA=#{Hardware::CPU.arch}
      RECC_REMOTE_PLATFORM_OSFamily=#{OS.kernel_name.downcase}
      RECC_REMOTE_PLATFORM_OSRelease=#{OS.kernel_version}
    ]
    system "make", "-f", "scripts/wrapper-templates/Makefile", *makefile_args
    etc.install "recc.conf"
    bin.install "recc-cc"
    bin.install "recc-c++"

    bin.install "scripts/wrapper-templates/casd-helper" => "recc-server"
  end

  service do
    run [opt_bin/"recc-server", "--local-server-instance", "recc-server", "#{var}/recc/casd"]
    keep_alive true
    working_dir var/"recc"
    log_path var/"log/recc-server.log"
    error_log_path var/"log/recc-server-error.log"
    environment_variables PATH: std_service_path_env
  end

  def caveats
    <<~EOS
      To launch a compiler with recc, set the following variables:
        CC=#{opt_bin}/recc-cc
        CXX=#{opt_bin}/recc-c++
    EOS
  end

  test do
    (testpath/"main.c").write <<~C
      #include <stdio.h>
      int main(void) { puts("recc works"); return 0; }
    C

    # The action digest is recc's cache key, computed without any CAS server.
    ENV["RECC_VERBOSE"] = "1"
    digest_regex = %r{Action Digest: (\h+/\d+)}
    cache_key = shell_output("#{bin}/recc-cc -c main.c 2>&1")[digest_regex, 1]
    refute_nil cache_key
    assert_equal cache_key, shell_output("#{bin}/recc-cc -c main.c 2>&1")[digest_regex, 1]
    refute_equal cache_key, shell_output("#{bin}/recc-cc -c -DGREETING=1 main.c 2>&1")[digest_regex, 1]

    system bin/"recc-cc", "main.o", "-o", "main"
    assert_equal "recc works", shell_output("./main").chomp
  end
end