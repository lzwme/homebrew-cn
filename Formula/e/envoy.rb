class Envoy < Formula
  desc "Cloud-native high-performance edgemiddleservice proxy"
  homepage "https:www.envoyproxy.ioindex.html"
  url "https:github.comenvoyproxyenvoyarchiverefstagsv1.33.1.tar.gz"
  sha256 "eddd1e4be75fc0606a5e721d3c219063b34504169da162a1615afbf4f9910e42"
  license "Apache-2.0"
  head "https:github.comenvoyproxyenvoy.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df87f1ae96a58efb9e2804785faac2ace764d193d5a4ee6e1ea667bc315e62c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "175fa30317bb088604a264a311f4649ee949fd724a3bef02ea06218c0e5f1fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d9590565d79938ee4713aeccddc86105736d5cb0fe60312c40b5282e4e5b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb0d812a92b719e264687e6470321bc6b64bcf2fd1717fde3bad55ef0c8a4b01"
    sha256 cellar: :any_skip_relocation, ventura:       "104ec9095b6d706ea0fd2f543df8517a6ab6f56025d20e3083713ea86ee03f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0fd496e0687eaef474e902e2191d276f187dea3da9c6070752aeccb6382b5a"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxyenvoy#16482
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

  # https:github.comenvoyproxyenvoytreemainbazel#supported-compiler-versions
  # GCCld.gold had some issues while building envoy 1.29 so use clanglld instead
  fails_with :gcc

  def install
    env_path = "#{HOMEBREW_PREFIX}bin:usrbin:bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --define=wasm=disabled
    ]

    if OS.linux?
      # GCCld.gold had some issues while building envoy so use clanglld instead
      args << "--config=clang"

      # clang 18 introduced stricter thread safety analysis. Remove once release that supports clang 18
      # https:github.comenvoyproxyenvoyissues37911
      args << "--copt=-Wno-thread-safety-reference-return"

      # Workaround to build with Clang 19 until envoy uses newer tcmalloc
      # https:github.comgoogletcmalloccommita37da0243b83bd2a7b1b53c187efd4fbf46e6e38
      args << "--copt=-Wno-unused-but-set-variable"

      # Workaround to build with Clang 19 until envoy uses newer grpc
      # https:github.comgrpcgrpccommite55f69cedd0ef7344e0bcb64b5ec9205e6aa4f04
      args << "--copt=-Wno-missing-template-arg-list-after-template-kw"
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "toolsgithubwrite_current_source_version.py", "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin"bazelisk", "build", *args, "sourceexe:envoy-static.stripped"
    bin.install "bazel-binsourceexeenvoy-static.stripped" => "envoy"
    pkgshare.install "configs"
  end

  test do
    port = free_port

    cp pkgshare"configsenvoyproxy_io_proxy.yaml", testpath"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end

    fork do
      exec bin"envoy", "-c", "envoy.yaml"
    end
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}clusters?format=json")
  end
end