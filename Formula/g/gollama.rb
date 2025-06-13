class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https:smcleod.net"
  url "https:github.comsammcjgollamaarchiverefstagsv1.34.0.tar.gz"
  sha256 "4aa1020b265b9d0323a2026bfe57d48085f69c23e82a9d8f75e314b3fc1ca9c7"
  license "MIT"
  head "https:github.comsammcjgollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6ad2430354fb30043f56a62fb50189dfb0bd73009f10449348f3f1613dc3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9368fa19f2937664eb15457bddaf8cae23aec35fa175df1ade6ddc32803c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c969a58af90135a5c67c936e43e9c65a3dcd088b46c9e4970e39aad005d6ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4ee031c44a0bc43b50fc4f92bf30cc3f065cfe00ceb2e9267a2edd47c09314"
    sha256 cellar: :any_skip_relocation, ventura:       "360aed2a90f80a6b4917c902a4102c7fefd5f377f10ccfcbb222b61b3a990e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2ff844892e70515dc8433454b84d2b28d4b16a847a7ab6fc3677e0a3574c81"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output(bin"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin"gollama -h http:localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end