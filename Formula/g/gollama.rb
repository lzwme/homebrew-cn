class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://ghfast.top/https://github.com/sammcj/gollama/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "3054b91c1719453b13584952c107e98687f53a302108613a1068f9ede64a014a"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd0906313cfec7c676899ad62cf411c4b3d09cc0641ff7c013c2dc288649f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d7a3cd8527e8d5333927e459acc098b46742852d96d8e38c8139c2b0686e3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0d820c9b4682dab74920e4027a4a99dfedf6e79cb484ef2f3be6b03e4008f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "5178d1222b8f03f7f81cc0a91ad881ff5a578570e85edeac783abd185d06404b"
    sha256 cellar: :any_skip_relocation, ventura:       "734d5d601f7db2e3d38fc65a8689feac03518c7db4d7eb7815b88ea5e6419982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4776a3cde29c8040e6508ae1f92c1feeeb1ea10b4c38894e2c619e29b963708"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end