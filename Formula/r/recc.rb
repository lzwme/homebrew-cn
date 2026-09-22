class Recc < Formula
  desc "Remote Execution Caching Compiler"
  homepage "https://buildgrid.gitlab.io/recc"
  url "https://gitlab.com/BuildGrid/buildbox/buildbox/-/archive/1.4.26/buildbox-1.4.26.tar.gz"
  sha256 "9d08ae805aef1825433e1456968251f5e5b9162512535c0ac6abd9e51dc6c384"
  license "Apache-2.0"
  head "https://gitlab.com/BuildGrid/buildbox/buildbox.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "6fd261f4b82d6b467f3b20b4ef8d015babd1f7a45e9796a4166c491aad144fdb"
    sha256 arm64_tahoe:       "6c8a99f3a6637c366003dc707819455f8b3f68232aba66d9a4a7f8d8b9fac114"
    sha256 arm64_sequoia:     "1dbf6eb18de555cb7d4b23dc0f755e336f3ef0b97b73d83d77741bcd182b2398"
    sha256 arm64_linux:       "a0b478795e9c7f57dc30dced3254e0227a1ba32a9e8373ce6d83d140e87f0199"
    sha256 x86_64_linux:      "a73880791f5bed4398da47306eadf16c5f242e5339c21236a08c36797a28133c"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build # for envsubst
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "tomlplusplus" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "grpc"
  depends_on "openssl@3"
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