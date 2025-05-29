class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.8.0",
      revision: "aa25aff10d1ccc6dd4e85952678d63946bdf89dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9419e6c02c19b9315be9d4c457ef5f192a24276906cd9c71c8644b23457a470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a86c2bd7dc3b83d35e60a9bc29fd8da668e3082d5ba5f50e0fa0583198bf69d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02d945b825c5868eb535b657e0eac172c5a231fea89c4bbe005755c52030c292"
    sha256 cellar: :any_skip_relocation, sonoma:        "1100b4d893d55edd13a2e1a74d9d6dd0923b84868d2074381bf21cdf1c6977d3"
    sha256 cellar: :any_skip_relocation, ventura:       "20a9aebbfc7535777c5e0b3959380f8b51d4fa8c53a4aa718c7850f5160fc7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff84c03888546f42004e5e50257c3fe07a33fd65244898a2becca78bb50340d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2509bc3d486b2c6f6cbec5adfe7daa008142637caf3904bbd9c06d855f1f9247"
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