class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.30.4",
      revision: "229a1303fb746393b784da791c30bebc0475f1af"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ca3874eb7f6da4d455bc7185fae2dc60c331d64254e55b5ce7e0ba66d55e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9baa499dc47de0404d13ded7fc9c9e0e351247d31210d156df2e9e4c111f9567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccbbbbe27a56e972b4b885da7c6f0ee77eb879caee6855a8eb87bdbb95becf1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a62bb134703ff342adc68fc1a9a75f11643962d7f44fd193b89679bc54899f"
    sha256 cellar: :any,                 arm64_linux:   "9f05039a634006cba5746c50874e954604faf6802721180d08f0246c9fb72d85"
    sha256 cellar: :any,                 x86_64_linux:  "a349e6abaf4f28ff40e18f392430eeb73aa28737b6f7f51eb1bbe2b41660d43b"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      if build.stable?
        # Fixes x/imagegen/mlx wrapper generation with system-installed mlx-c headers.
        # upstream pr ref, https://github.com/ollama/ollama/pull/14201
        patch do
          url "https://github.com/ollama/ollama/commit/c051122297824c223454b82f4af3afe94379e6dd.patch?full_index=1"
          sha256 "a22665cd1acec84f6bb53c84dd9a40f7001f2b1cbe2253aed3967b4401cde6a0"
        end
      end
    end
  end

  conflicts_with cask: "ollama-app"

  def install
    # Remove ui app directory
    rm_r("app")

    ENV["CGO_ENABLED"] = "1"

    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X github.com/ollama/ollama/version.Version=#{version}
      -X github.com/ollama/ollama/server.mode=release
    ]

    mlx_args = []

    # Flags for MLX (Apple silicon only)
    if OS.mac? && Hardware::CPU.arm?
      mlx_rpath = rpath(target: Formula["mlx-c"].opt_lib)
      ldflags << "-extldflags '-Wl,-rpath,#{mlx_rpath}'"
      mlx_args << "-tags=mlx"
    end

    system "go", "generate", *mlx_args, "./x/imagegen/mlx"
    # Build into libexec so the mlx runner's required `<exe_dir>/lib/ollama/`
    # sibling can be populated without tripping the non-executables-in-bin audit.
    system "go", "build", *mlx_args, *std_go_args(ldflags:, output: libexec/"ollama")
    bin.install_symlink libexec/"ollama"

    # The mlx runner dlopens MLX libraries from `<exe_dir>/lib/ollama/mlx_*/`.
    # Using `opt` keeps the link stable across mlx-c version bumps.
    if OS.mac? && Hardware::CPU.arm?
      (libexec/"lib/ollama/mlx_metal_v3").mkpath
      ln_sf Formula["mlx-c"].opt_lib/"libmlxc.dylib", libexec/"lib/ollama/mlx_metal_v3/libmlxc.dylib"
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
  end
end