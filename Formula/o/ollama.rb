class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.15.4",
      revision: "6a7c3f188e679b1849e4618754b25dc9c19541d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4925cac07c36a1af746191da00be1ce959cdc0b6a12c73327150dd7fffa96517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3051bd65c3165f25a055c20b484e52d54077e08fb4676ed94ac53a18ea395f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec1ce88667c4a2b65e62bf325a68e36aa03102e213ee2b322a03f6e0ac06eded"
    sha256 cellar: :any_skip_relocation, sonoma:        "57201483ce5fab0449c512aa7753c94f11f1ae3c67e9e527c0ca22c6ce6146cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd685848fb003b49877e1a880b489b38d9948f08739562b5a17262f749bf025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ee932dc07a7f1e5fb836ee44a465e70bd9ac69e0cb124a14b8f7858b49cd42"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  on_macos do
    on_arm do
      depends_on "mlx-c" => :no_linkage
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

    system "go", "generate", "./..."
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