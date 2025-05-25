class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.7.1",
      revision: "884d26093c80491a3fe07f606fc04851dc317199"
  license "MIT"
  head "https:github.comollamaollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82398671c6550d59c91ed0360d229e88eb97069abe0bebcdabd04c3956238373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9717f7fa3f4e08753e97afe2ee644e2288c32ec590e7a0bf3c59ea90aa1944"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab5176391b71f83019b0567634e882cea275f581256fbec69a261d69ed7d5253"
    sha256 cellar: :any_skip_relocation, sonoma:        "1622fdd112fa8a0298db636075b606692c540089cf3d12004147bb7a98f475eb"
    sha256 cellar: :any_skip_relocation, ventura:       "884a6c630534762385b9c05aaa95270f8bcba37523ae64ef6b5da724e8982421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1c885c84031b741252012b30ebdf793f657a42e5624a0cb76751c2a44162c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5755d2eede14c53257ee043eedfc1a3aa58c921b8e5d71d8a64ad5bd0969a8d"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  conflicts_with cask: "ollama"

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.comollamaollamaversion.Version=#{version}
      -X=github.comollamaollamaserver.mode=release
    ]

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
    environment_variables OLLAMA_FLASH_ATTENTION: "1",
                          OLLAMA_KV_CACHE_TYPE:   "q8_0"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end