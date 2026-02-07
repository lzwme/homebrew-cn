class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.15.5",
      revision: "8a4b77f9daccc2509596753c0cb5564918b4ada0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18e212c202bcd88bd681d793d1f90b92ac7f4e5f8a5d4067e4af9283c3830cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89cf67b613178f5164d29c77596c4341333596b2aa79584a3ca136599a6185ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aa5e82cc11de87ef28a3f42a202713c75aa357f22b5e2549469d0229aa2483a"
    sha256 cellar: :any_skip_relocation, sonoma:        "47966bf386891dc937c0ff368c6e315e61e55fa235827133783b198051724759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb98b15290f8742eaf2f7241de16fe7728f9ae80700e7bd7f6184ff840efe9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d07124e130b66d8f063b7165aea748aef01968a8d85b76f21b9bdc66429a669"
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