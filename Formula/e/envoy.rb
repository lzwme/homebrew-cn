class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://ghfast.top/https://github.com/envoyproxy/envoy/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "bdd9d646b30a3d048f1ff6b2719f81b9e14c0e187950ea8f4812bf5207f42bfc"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4c484d8913a88d5036a25613ef80835e3817a23d5b7458b6532713d259d8c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934778c2d7d7796c3c312ed2163ae97366dd7977054e1a5d31d81dbdcb9fc260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7e98ccfe84f4373ae3e53a2debd76e12d71cb8db41cbb5264803daf1ffbd75"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf89b41a6db2dad33020a8e8974fd1c646424667dd6ebde5f9c887ee7b19704d"
    sha256 cellar: :any_skip_relocation, ventura:       "5193aee05fe54295e29def10d997f9854edcd4455683b011c5ea234a49fa16ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f420ac4cca2f1956d3556d74012ced602df25cf1e8cfa6eb0f51366d0e38d132"
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