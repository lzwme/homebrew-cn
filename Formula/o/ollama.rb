class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.32.13",
      revision: "0f25c31bd53b64dc3fcc8fce0bde954159a67a58"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5be7a4b35d3c34ee65b067a2406aa68c8f15dd48743117052294eaeadc38b30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cccaf7c8b872b9c3719c3c0bb751bdfbc60a195a08fb04d2edc99a06a7ce668d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e74f9d2a2de1d3ce5d7e6c1838867e1359ede2a1eebfe4016f4858c39e457de"
    sha256 cellar: :any,                 sonoma:        "a51932425a99e496292ec2d6becf3a11fd49a75e7fdb7e59a0857d5d6c415d8e"
    sha256 cellar: :any,                 arm64_linux:   "f4b4dd15bc29914bf8e8184dfb2d5c259bd7ae64f46d44e38dd9f7da24b08c87"
    sha256 cellar: :any,                 x86_64_linux:  "fa2b7bfe8cad3b4e78a9e298bf9ee39a5c2040323739646fd74f009e25da8352"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage
    end
  end

  conflicts_with cask: "ollama-app"

  # Pinned dependency required by llama-server
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b10380",
        revision: "0b1bad14ff204627636aeb1de22ddcd5acb859d4"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/ollama/ollama/refs/tags/v#{LATEST_VERSION}/LLAMA_CPP_VERSION"
      regex(/^v?b(\d+)$/i)
    end

    # fix: don't build AMX by default with Apple clang
    patch do
      url "https://github.com/ggml-org/llama.cpp/commit/1f92170dc9d4620b5aadb9bacba502c726e5b587.patch?full_index=1"
      sha256 "1e51afe4b8cfed5653289270064370d926258b5bbd662a93eac240d7a37f2735"
      type :unofficial
    end
  end

  def install
    # Build llama-server
    llama_source_dir = buildpath/"llama.cpp"
    llama_source_dir.install resource("llama.cpp")

    preset = (OS.mac? && Hardware::CPU.arm?) ? "darwin" : "cpu"

    args = %W[
      --preset #{preset}
      -DFETCHCONTENT_SOURCE_DIR_LLAMA_CPP=#{llama_source_dir}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DCMAKE_INSTALL_RPATH=#{loader_path}
    ]

    system "cmake", "-S", "llama/server", "-B", "llama-server", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "llama-server"
    system "cmake", "--install", "llama-server", "--component", "llama-server"

    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    mlx_args = []

    # Flags for MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      mlx_rpath = rpath(target: formula_opt_lib("mlx-c"))
      ldflags << "-extldflags '-Wl,-rpath,#{mlx_rpath}'"
      mlx_args << "-tags=mlx"

      # Generate wrappers from our mlx-c; the vendored headers are newer and declare symbols it lacks
      mlx_headers = buildpath/"x/mlxrunner/mlx/include/mlx"
      rm_r(mlx_headers/"c")
      mlx_headers.install_symlink formula_opt_include("mlx-c")/"mlx/c"
      system "go", "generate", *mlx_args, "./x/mlxrunner/mlx"
    end

    # Build into libexec so the mlx runner's required `<exe_dir>/lib/ollama/`
    # sibling can be populated without tripping the non-executables-in-bin audit.
    system "go", "build", *mlx_args, *std_go_args(ldflags:, output: libexec/"ollama")
    bin.install_symlink libexec/"ollama"

    # The mlx runner dlopens MLX libraries from `<exe_dir>/lib/ollama/mlx_*/`.
    # Using `opt` keeps the link stable across mlx-c version bumps.
    if OS.mac? && Hardware::CPU.arm?
      (libexec/"lib/ollama/mlx_metal_v3").mkpath
      ln_sf formula_opt_lib("mlx-c")/"libmlxc.dylib", libexec/"lib/ollama/mlx_metal_v3/libmlxc.dylib"
    end
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn bin/"ollama", "serve"
    begin
      sleep 3
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    # Test MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/ollama --help 2>&1")
      assert_match "libmlxc.dylib", output
      assert_match "libmlx.dylib", output
    end

    # Check llama-server binary; it needs a model as upstream builds it without router mode support
    resource "homebrew-test-model" do
      url "https://huggingface.co/ggml-org/models/resolve/499bc8821c6b12b4e53c5bffcb21ec206f212d81/tinyllamas/stories260K.gguf"
      sha256 "270cba1bd5109f42d03350f60406024560464db173c0e387d91f0426d3bd256d"
    end
    testpath.install resource("homebrew-test-model")

    require "pty"

    llama_port = free_port
    output = +""
    r, _w, pid = PTY.spawn(libexec/"lib/ollama/llama-server", "-m", "stories260K.gguf", "--port", llama_port.to_s)
    begin
      timeout = Time.now + 20
      until output.include?("listening on")
        raise "timed out waiting for llama-server to start\n#{output}" if Time.now > timeout

        begin
          output << r.read_nonblock(1024)
        rescue IO::WaitReadable
          sleep 0.1
        rescue EOFError
          break
        end
      end

      assert_match "listening on http://127.0.0.1:#{llama_port}", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end