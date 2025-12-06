class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://ghfast.top/https://github.com/envoyproxy/envoy/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "1deec2031b935b6520eb1b5941efd5065c0f38ffcaba5230c52db6e2f3c8b9eb"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73e2686330b6c9e760309164a6fe225ead5560ab89ce6a1209d8c2746215c7b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2230073e91d7c0e36a42466267b713f6a48196bd1177a06044d6999f912dea4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8561123629ab04c7929f08366a8f5f0ce266bf26ef69592703c29cc87ca6e211"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e2619a48ba2f9c6866b0ccec31405329813078651556b136a47737e5f3ebac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ad2bd4b77df29536e770fb9b2486dccc444131be97fb6ab749cfae2e6feea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9fc347b8dccf3befbb6356e44330a7ebf7232c7fbc04a5903a76394b4b1a6cd"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build

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

      # Workaround to build with Clang 21, upstream also ignores this warning
      # https://github.com/google/cel-cpp/blob/439003a0016ed7ace068cffdf494357a3f75e3b2/common/values/value_variant.h#L735-L743
      args << "--copt=-Wno-nontrivial-memcall"
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