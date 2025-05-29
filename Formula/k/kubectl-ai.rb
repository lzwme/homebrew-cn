class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https:github.comGoogleCloudPlatformkubectl-ai"
  url "https:github.comGoogleCloudPlatformkubectl-aiarchiverefstagsv0.0.11.tar.gz"
  sha256 "15fd892b06b2b992d96024c7880869ea929f535153fe743de7e0a4088e702aa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8e865c902c74ade666ae2b0856ab64d0638061c0df24347cfd91c76e0782cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8e865c902c74ade666ae2b0856ab64d0638061c0df24347cfd91c76e0782cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8e865c902c74ade666ae2b0856ab64d0638061c0df24347cfd91c76e0782cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "abec5a1c68d2e1b1a3c7677883515a72f115878b2691b5569d60c1ebf8be0195"
    sha256 cellar: :any_skip_relocation, ventura:       "abec5a1c68d2e1b1a3c7677883515a72f115878b2691b5569d60c1ebf8be0195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef37269709afc0e92ac134901e6600241a3d028af29f2aa78432705352e48ed"
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