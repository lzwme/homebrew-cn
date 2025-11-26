class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.613.57.tar.gz"
  sha256 "1c247391d94d6b3087552eb1310403e6c6e82c9a9f446c3a7209b71bb86ab359"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8651253992c8afa208c7937363fa5f8104ba5542ca5ab34d210e6c96a0cb40a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "807d534a47f4c696f12ea8af5ec055ea58fe074b0f75199c38b20ed57e479541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0b3d8aa5dcf2c7902eb2de2ffdbce9527f10729922e9e59988bbfb66fbc9f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b884719ef4d206389c1584b996e59a3343e9be8c6305b56c14a268a7c74404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb2eee624972889fdeb1339f43a889f8864de94fefe8e7d231ae1803f516f01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "072901b718c1fb1008a8b3304a096bdfd0eceadd94eec12e95702222a56ae1fb"
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