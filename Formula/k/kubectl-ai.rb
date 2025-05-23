class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https:github.comGoogleCloudPlatformkubectl-ai"
  url "https:github.comGoogleCloudPlatformkubectl-aiarchiverefstagsv0.0.10.tar.gz"
  sha256 "a65aacf0b9590d52757b6c7824d2194ed582e8b9bc07aef85199ab9b3dc4acfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a557b4fa3ea59f480ab99eb0e8ebfb18949941659306c21958bcb1771aa235b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a557b4fa3ea59f480ab99eb0e8ebfb18949941659306c21958bcb1771aa235b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a557b4fa3ea59f480ab99eb0e8ebfb18949941659306c21958bcb1771aa235b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8da27f4014c17b367e8b5e3238dc1534d494cead2ef1d7d7fd834673fa3b2fdb"
    sha256 cellar: :any_skip_relocation, ventura:       "8da27f4014c17b367e8b5e3238dc1534d494cead2ef1d7d7fd834673fa3b2fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de8cce18608b061b8a1e6ac9408086db4598144a534ff3aaf683f2cd2d1d86c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmd"
  end

  test do
    assert_match "kubectl-ai [flags]", shell_output("#{bin}kubectl-ai --help")

    ENV["GEMINI_API_KEY"] = "test"

    PTY.spawn(bin"kubectl-ai") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "Error 400, Message: API key not valid", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end