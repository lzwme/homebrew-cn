class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://ghfast.top/https://github.com/envoyproxy/envoy/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "31ce14bee8f21b409743083ccb2147c6ac968a6d4338d7002f4126d8ddd67b75"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be3835e947c77989d1e5403114b32b3c28666e2154c8e39dfa885a6fb50c2a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd941274bc66d6ec182dbce57672a91f1e23babccee4ed1c21d63ec49e54afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae1abb063af7a3a9e488ed7dd3cfe43ae663b3b679f1c707429387b4830d446c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7554e0ad0d4aa744a685ef3cc761c8d864828a9725e86132e60543e2cee27274"
    sha256 cellar: :any_skip_relocation, ventura:       "55d6a7b0d47108220f3ef53ce5e056eaaa01bc1ccef19d1244a8893d5589691c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28b488486fcfd031504a3b1699f77499c78ab669f48c611fd2b9ccb70a72ff41"
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

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "lld" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  # GCC/ld.gold had some issues while building envoy 1.29 so use clang/lld instead
  fails_with :gcc

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --define=wasm=disabled
    ]

    if OS.linux?
      # GCC/ld.gold had some issues while building envoy so use clang/lld instead
      args << "--config=clang-common"

      # clang 18 introduced stricter thread safety analysis. Remove once release that supports clang 18
      # https://github.com/envoyproxy/envoy/issues/37911
      args << "--copt=-Wno-thread-safety-reference-return"

      # Workaround to build with Clang 19 until envoy uses newer tcmalloc
      # https://github.com/google/tcmalloc/commit/a37da0243b83bd2a7b1b53c187efd4fbf46e6e38
      args << "--copt=-Wno-unused-but-set-variable"

      # Workaround to build with Clang 19 until envoy uses newer grpc
      # https://github.com/grpc/grpc/commit/e55f69cedd0ef7344e0bcb64b5ec9205e6aa4f04
      args << "--copt=-Wno-missing-template-arg-list-after-template-kw"

      # Workaround to build with Clang 20
      args << "--copt=-Wno-deprecated-literal-operator"
    end

    # Workaround to build with Xcode 16.3 / Clang 19
    args << "--copt=-Wno-nullability-completeness" if OS.linux? || DevelopmentTools.clang_build_version >= 1700

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    pkgshare.install "configs"
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