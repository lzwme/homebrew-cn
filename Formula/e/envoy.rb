class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  license "Apache-2.0"

  stable do
    url "https://ghfast.top/https://github.com/envoyproxy/envoy/archive/refs/tags/v1.39.2.tar.gz"
    sha256 "4c897373699a45e848f4abf1892143f693c1d0bfd4414f73da57957697f35d6e"

    depends_on "llvm@18" => :build

    # TODO: remove once 1.39 includes host-toolchain support, upstream PR ref, https://github.com/envoyproxy/envoy/pull/47963
    patch do
      url "https://github.com/envoyproxy/envoy/commit/3806cefa801e337fe0ce182c00019079c03076a7.patch?full_index=1"
      sha256 "d2e5eea97cc244a3ba8d2dd9e477a02f2e757497213a49ea77c24d3f71aebe3e"
      type :backport
      resolves "https://github.com/envoyproxy/envoy/pull/47963"
    end

    # TODO: Remove once 1.39 reuses API CEL protos, upstream PR ref, https://github.com/envoyproxy/envoy/pull/47984
    patch do
      url "https://github.com/envoyproxy/envoy/commit/4160c05c1e935678e11fb5b690ce228a919ba8c6.patch?full_index=1"
      sha256 "cb5ca3f32d7222c7f24c99dafa4fbf542ae686b6c3afb6bbe3c84f4f0d7b08e7"
      type :unofficial
      resolves "https://github.com/envoyproxy/envoy/pull/47984"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba546537d84991d18cf85ff335c77102faa131f7ccdc9dbba04097399800bc7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9feb0cc33a499bbc29443e78f7142aaacbca16afe2978c25cd500b50a43b9b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79f7174c205aec69d72d01f671e1b8efb7ff39a43b11593457897d74a80ef462"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "171f44fcc1c070a2160a230f47be7506a4df5469f91a399acc1ef5f524b26bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7e4554ba922b938f99d197d10b5da2de877b07c046c389854e247f5adadbe1b7"
  end

  head do
    url "https://github.com/envoyproxy/envoy.git", branch: "main"

    depends_on "lld@22" => :build
    depends_on "llvm@22" => :build
  end

  depends_on "bazel@8" => :build
  depends_on "cmake" => :build
  # TODO: unpin go@1.26 when envoy updates to rules_go >= 0.62.0
  # ref: https://github.com/bazel-contrib/rules_go/pull/4641
  depends_on "go@1.26" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on xcode: :build
  end

  def install
    # Drop hickory DNS: its rust SDK pulls in mockall (incompatible with macOS)
    # and references `@llvm_toolchain_llvm` labels that aren't registered when
    # LLVM is injected via `BAZEL_LLVM_PATH`.
    inreplace "source/extensions/extensions_build_config.bzl",
              /^\s*"envoy\.network\.dns_resolver\.hickory":.*\n/, ""

    # Build with brew Bazel rather than Bazelisk downloading it
    rm ".bazelversion"

    # Build with brew CMake, Go, Ninja and Python rather than Bazel downloading them
    # https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-with-host-provided-toolchains
    # TODO: look into support via bzlmod
    if build.stable?
      inreplace "WORKSPACE" do |s|
        s.gsub! "envoy_dependency_imports()", "envoy_dependency_imports(use_host_tools = True)"
        s.gsub! "envoy_dependencies_extra()", "envoy_dependencies_extra(use_host_tools = True)"
      end
    end

    # Stage a local toolchain root to match official LLVM layout needed by upstream
    ENV["BAZEL_LLVM_PATH"] = llvm_path = buildpath/"llvm-toolchain"
    ENV["BAZEL_USE_HOST_SYSROOT"] = "True"
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    llvm_path.install_symlink(llvm.opt_prefix.children.select(&:directory?) - [llvm.opt_bin])
    (llvm_path/"bin").install_symlink llvm.opt_bin.children
    (llvm_path/"bin").install_symlink formula_opt_bin(llvm.name.sub(/^llvm/, "lld")).children if build.head?
    (llvm_path/"bin").install_symlink which("libtool") if OS.mac? # rules_foreign_cc expects Apple libtool for AR

    # Bazel cannot run in superenv. Also drop binutils as rules_foreign_cc CMake try-compile
    # can pick GNU ld from PATH and fail to link against Envoy's configured sysroot/toolchain
    env_path = (ENV["PATH"].split(":") - [Superenv.shims_path.to_s, formula_opt_bin("binutils").to_s]).join(":")

    bazel_args = %W[--output_user_root=#{buildpath}/user_root]
    args = %W[
      --compilation_mode=opt
      --curses=no
      --noincompatible_strict_action_env
      --verbose_failures
      --action_env=CMAKE_POLICY_VERSION_MINIMUM=3.5
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --repository_cache=#{HOMEBREW_CACHE}/envoy-repository-cache
      --jobs=#{ENV.make_jobs}
    ]
    if build.stable?
      args += %w[
        --noenable_bzlmod
        --@envoy//bazel/foreign_cc:parallel_builds
        --define=wasm=wamr
        --copt=-Wno-nullability-completeness
      ]
    end
    if OS.mac?
      # TODO: Remove once the configured LLVM linker supports Xcode 27 SDK targets.
      # https://github.com/envoyproxy/envoy/issues/47964
      # Set the bottle deployment target for LLVM actions and CMake subprocesses.
      args += %W[
        --action_env=MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
        --host_action_env=MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
        --copt=-mmacosx-version-min=#{MacOS.version}
        --host_copt=-mmacosx-version-min=#{MacOS.version}
        --linkopt=-mmacosx-version-min=#{MacOS.version}
        --host_linkopt=-mmacosx-version-min=#{MacOS.version}
        --linkopt=--ld-path=/usr/bin/ld
        --host_linkopt=--ld-path=/usr/bin/ld
        --features=-supports_start_end_lib
        --host_features=-supports_start_end_lib
      ]
    end
    if OS.linux?
      # lld needs help finding libc++.a and libc++abi.a in a non-standard path
      args += %W[
        --linkopt=-L#{llvm_path}/lib
        --host_linkopt=-L#{llvm_path}/lib
        --config=clang-local
        --repo_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1
      ]
    end

    # TODO: remove when unpinning go@1.26
    # `--config=macos` resets the action PATH to `/opt/homebrew/bin`, which hides keg-only deps
    args << "--repo_env=PATH=#{env_path}"

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git",
           "--github_api_token_env_name=HOMEBREW_GITHUB_API_TOKEN"

    system "bazel", *bazel_args, "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    # Copy the configs directory to the pkgshare directory.
    pkgshare.install "configs"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end
    pid = spawn bin/"envoy", "-c", "envoy.yaml"
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  ensure
    Process.kill("HUP", pid)
  end
end