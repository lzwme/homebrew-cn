class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https:github.comGoogleCloudPlatformkubectl-ai"
  url "https:github.comGoogleCloudPlatformkubectl-aiarchiverefstagsv0.0.9.tar.gz"
  sha256 "9cdcc413143572b90bdbf371369ad6a6d531a0f3579e5683f10eb69b38429424"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fa9f2850ff8828762fa6b7b512a3db7a260a9b784bdcf5330006669bd468bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fa9f2850ff8828762fa6b7b512a3db7a260a9b784bdcf5330006669bd468bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fa9f2850ff8828762fa6b7b512a3db7a260a9b784bdcf5330006669bd468bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1012527d33f13ab7545e55268e253deae30b0410019af53db7444fcf3bdfe85"
    sha256 cellar: :any_skip_relocation, ventura:       "b1012527d33f13ab7545e55268e253deae30b0410019af53db7444fcf3bdfe85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a29a9f1c9edeac89a5db2c02fb82792bbb7e2544e34bb560642512f17eee7838"
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