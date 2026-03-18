class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.18.1",
      revision: "bcf6d55b54b9792083e785b5cfaf6ad8eb9f8dca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f135bccd3136f7fbafa1ab94581a3b596b92402887b92a69a118c603e01aaa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee5a6189de48b49e4854535fcd929793102e456399600fc443c2ccbccb7712d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c25cdbdf5b490fa494424d2f530f3f27bb4ff0c9768765e47dcd100f3ae4baf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc651c4603fe0b76e242e401851f7416475b9313024b602b70f11f532754e3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ef2bd3c10f5c16889b24f24ccff498c464e64cde7f0ac86f82ba87f5447252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165f8e47cc37354ac09da2c01c117d94b59c964a64b5c39a8eb3096f35c17853"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage

      # Fixes x/imagegen/mlx wrapper generation with system-installed mlx-c headers.
      # upstream pr ref, https://github.com/ollama/ollama/pull/14201
      if build.stable?
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
    system "go", "build", *mlx_args, *std_go_args(ldflags:)
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
  end
end