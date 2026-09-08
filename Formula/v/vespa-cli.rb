class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.751.13.tar.gz"
  sha256 "bb5c59e62012bd0ce71bb0cdadb9a60ed9d7dde0662fdc942d81e0e4bd8feb53"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c38dc0edb66e9270182f12b217ca0a5833fb91e0e2208c283001085bb6b99863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6583a74fc5e81594cdc0bfb0c0b101539e2d9f19bfbb3fb6ad0af4133cf4bc33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd89adf2ba5bba6f1e95e7e47fd2759bff66fc97eea13aef7c1813aad057d197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05550336bfeed551f7502f877a3e13f5daf88203b9bbbe9a31d39b2917aaf179"
    sha256 cellar: :any,                 x86_64_linux:  "4298a8d682459b8502271f646acb7238b3f891dcb507640cf14542462ea1d4c4"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
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