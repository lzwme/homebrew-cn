class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://ghproxy.com/https://github.com/envoyproxy/envoy/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "44883e15603357f7fbc448e88fae37bcfa3c9381ccb4e77effbba14598cbbe40"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e78cd9402afbc072bbdfd2ecb80ce1ebef7a426fa1744a5b18ef552d69abc022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fb7f5508b11797116bb3ef8c92553e9d54cf3ea9adcde728131af7d160b2da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cb717748c8ca2ea46f92346727eff541a7b28ca09f7edd39d9627f860e8faa2"
    sha256 cellar: :any_skip_relocation, ventura:        "cd75a875e2bc18ac54ac64ac7af315d90bc9172032c5427db450671ca1ccf999"
    sha256 cellar: :any_skip_relocation, monterey:       "b0b0972660b6c23be523cf6c96c487db23e8ed99469b9dc9ed55634e06bd7f2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fdc9a8135d40e594d7277eb3a57a9ab3d904233d79859af260da667afb8fda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158eec50a2b8c266b036ee0679f95fbee3e528868776318df28ef6425f989f9d"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  fails_with :gcc do
    version "8"
    cause "C++17 support and tcmalloc requirement"
  end

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    if OS.linux?
      # Build fails with GCC 10+ at external/com_google_absl/absl/container/internal/inlined_vector.h:448:5:
      # error: '<anonymous>.absl::inlined_vector_internal::Storage<char, 128, std::allocator<char> >::data_'
      # is used uninitialized in this function [-Werror=uninitialized]
      # Try to remove in a release that uses a newer abseil
      args << "--cxxopt=-Wno-uninitialized"
      args << "--host_cxxopt=-Wno-uninitialized"
    else
      # The clang available on macOS catalina has a warning that isn't clean on v8 code.
      # The warning doesn't show up with more recent clangs, so disable it for now.
      args << "--cxxopt=-Wno-range-loop-analysis"
      args << "--host_cxxopt=-Wno-range-loop-analysis"

      # To supress warning on deprecated declaration on v8 code. For example:
      # external/v8/src/base/platform/platform-darwin.cc:56:22: 'getsectdatafromheader_64'
      # is deprecated: first deprecated in macOS 13.0.
      # https://bugs.chromium.org/p/v8/issues/detail?id=13428.
      # Reference: https://github.com/envoyproxy/envoy/pull/23707.
      args << "--cxxopt=-Wno-deprecated-declarations"
      args << "--host_cxxopt=-Wno-deprecated-declarations"
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    pkgshare.install "configs", "examples"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end

    fork do
      exec bin/"envoy", "-c", "envoy.yaml"
    end
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  end
end