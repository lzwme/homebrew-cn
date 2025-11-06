class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.603.19.tar.gz"
  sha256 "0a420fc5fb2bb120eea20ee80c56c25e34e52e9a8d016d6fe7768ec41b427517"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c605b2834f44724ad054599b445433e9d175f934f036a1582f41f1712f1932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a5082f36b70e8056d781e30f6c42c8e0a402c3de7514d76f3f7345d16dd4bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b399ab31dec7e8d27f7847b42022742d93fe715a5aea43612c1a06cd7f6bda57"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbd8ff3f2333b5cb7e93ff423e74be54da155c34c86332ff5ac994243e9b3115"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "289bc28f4cf4d7be839f2a80d61d566f773dbb1df0bd50f6cf4b4edb628affd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a6e56bd30ed640ac2ae9f65d58ee6c144a4a9eeb3cec2056e11f81c9a85f80"
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