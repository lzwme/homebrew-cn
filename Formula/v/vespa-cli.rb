class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.620.35.tar.gz"
  sha256 "303cb826483c4f228e44b088d2ae265f13ff4c1604689d585611a4a36250cffa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9d0c07373ed88adeb81a6a650988668c902ec558cb588fc66c92e60a145ac8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0d3107dcadf06603bbb65c11d796c2e23eadd79ed94fb35d1c2ab551cc1fb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6853278c3a0a53545a0bcb817f24f6526ae6c65edfd17c385bb8280c3606ec83"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e67bd83133505075a3519d2dffb30e9d002d2d390526abb8f4d0bba8cef773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "867b6eb8777f79342f5b1553ea28d3b72e2b8cd92a43a58a43daf8731c9cabc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16a26559e302fcf41c2e7be6455e4942e77245b5b0117bb396d6dda223c633c0"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end