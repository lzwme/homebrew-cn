class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://ghproxy.com/https://github.com/envoyproxy/envoy/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "e86245011c7d36e0ffbd08d1b584944e2faa03e2ef516dddbab5091650960a63"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bb69bb06f0e710501fc692c74a04692c4e1bd7fdb0c26747bf11f74fcccaf9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3e1eda156daeab58dbac91397ad71c1126207a0cac2a34b71add6f5a5b4f2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "187be248a06f082e13f76446efd95e3cdae077156cb950fa588e82ced4c76bf0"
    sha256 cellar: :any_skip_relocation, ventura:        "ad3b3d40274e3b4ea98b8f347f444aadebdc0708a0499f8e686230edb9eeae8e"
    sha256 cellar: :any_skip_relocation, monterey:       "6c067281105c83477b8c9eb6246ee0626759b885141947c47c7b8a4a072d64cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4c0858494229e950d0cadf1b460bf6c84eb580fc0a14ca09b6fcf9b66cf3e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296e849baa6e01d838d7d4dccc41eef0045e720190138f695f1720ff210ca52d"
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
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

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

      # To suppress warning on deprecated declaration on v8 code. For example:
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