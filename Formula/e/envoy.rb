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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6044fed6d85bc716e24697d4164604f9c8ec1ded2046618921ca0fd0587b730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be32b6b78bee40ec4b23fe0729d76e2a926e177810bae4d9864f64ad3f20e8ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f57b7406b93f1273c2890234863c19ad33f98eda414977267c50d9c96303d84a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c829a7043455832d967eed9d5ba3d2f417d28b5b612b8e5104f2afd88e647f3"
    sha256 cellar: :any_skip_relocation, ventura:       "0ee683551881264108fa7b6b3257fd7ea180549655cd2bcd69a57338b9ff9195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32b17beece54c216f717a507715aff997db93dc6faa7088d4fff2599dd92d45"
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
      --define=wasm=wamr
    ]

    if OS.linux?
      # GCC/ld.gold had some issues while building envoy so use clang/lld instead
      args << "--config=clang-common"

      # Workaround to build with Clang 20 until envoy uses newer dd-trace-cpp (with newer nlohmann-json)
      # https://github.com/DataDog/dd-trace-cpp/commit/a7d71b5e0599125d5957f7b8d3d56f0bcc6ae485
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