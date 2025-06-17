class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https:github.comGoogleCloudPlatformkubectl-ai"
  url "https:github.comGoogleCloudPlatformkubectl-aiarchiverefstagsv0.0.13.tar.gz"
  sha256 "17f77ff940fb234a521c5ed755b547fb9ecbcc815733514a2669e44723319d5a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee951ecc463306bc5298c19326e8df1613a33b37581c9daab1b700686d7b7b9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee951ecc463306bc5298c19326e8df1613a33b37581c9daab1b700686d7b7b9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee951ecc463306bc5298c19326e8df1613a33b37581c9daab1b700686d7b7b9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e752dcafc243778426fe66c57b861897212a21b61c547003e0008bf1ab83da"
    sha256 cellar: :any_skip_relocation, ventura:       "85e752dcafc243778426fe66c57b861897212a21b61c547003e0008bf1ab83da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9eec60ceb40e87e250b256ce7413a167b93984ac3142997cfcb381330af256"
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