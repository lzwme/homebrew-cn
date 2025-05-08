class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https:github.comGoogleCloudPlatformkubectl-ai"
  url "https:github.comGoogleCloudPlatformkubectl-aiarchiverefstagsv0.0.8.tar.gz"
  sha256 "d4547d69a2b1014ed23989349eb210829373d43b94514896d2d4fecb6bb3488a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecddd7b1d507131d8eee3d2d0d96a752328c8e8b36eca148d3e9358a97f1699c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecddd7b1d507131d8eee3d2d0d96a752328c8e8b36eca148d3e9358a97f1699c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecddd7b1d507131d8eee3d2d0d96a752328c8e8b36eca148d3e9358a97f1699c"
    sha256 cellar: :any_skip_relocation, sonoma:        "22491d946f000e2cc97310fba5748fcdb955f49635ba4556b7927dad682fd69d"
    sha256 cellar: :any_skip_relocation, ventura:       "22491d946f000e2cc97310fba5748fcdb955f49635ba4556b7927dad682fd69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e894616c1423a4a1a75ddcee5782445bf4d6ddfd5e93b7efa1239baf9ee4b7c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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