class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https:ollama.com"
  url "https:github.comollamaollama.git",
      tag:      "v0.1.37",
      revision: "41ba3017fd74dfce9a3dc00160f29befec85a41b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "643f58040b29271f6d98db7facfdb773f2836ff1c5f0630deb88cf60b37490af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24442590db1122793d567310cca76678608bdeab5a571d91151d6016f7374ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed64e512e50e2d34d0190aa4033e80ec86bce5562ebe71a264a3ff4b313d75f"
    sha256 cellar: :any_skip_relocation, sonoma:         "497cb0a8edfdb83ff2c6d8e06dd169975f5908f7b045fb62c8ff4c10159e4ca8"
    sha256 cellar: :any_skip_relocation, ventura:        "7e7307d207d0233dd88bb2a9f5e1b8632489553572f02ad2590a1de59158130e"
    sha256 cellar: :any_skip_relocation, monterey:       "e0af23b569d49bbbbc591eca5378326933e356aa83cec7ef7e582c86e747a2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2cab3f9afe24ffbfee73321810ce70d648ba09b99c0cbd994fb999bb214009"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "versionversion.go", var Version string = "[\d.]+", "var Version string = \"#{version}\""

    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var"logollama.log"
    error_log_path var"logollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end