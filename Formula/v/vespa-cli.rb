class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.504.27.tar.gz"
  sha256 "75dac429dab2f15c0439c51cabd0dc47d91455def499597614574ec83c30b1e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86bdd99789e8002dd6d39ec80bf0b8a8df0b494c10373a0c9120a40f3e9d628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095d35dac7202781f2ccc83965609807a4ffffa0313d3e2d3cc357796a8b00a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5617a29675e6cc741a789b9d5f65116ae12859238cda14a7b4c0c0a7f3f8d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb3e0434f1afd231d9a0044830eccacff79d68b3f53dcd5fd73e55c77fcdbdd"
    sha256 cellar: :any_skip_relocation, ventura:       "be014fd1d4e3c42d17647cff0c9ca812785fe8d3db5adfb2c63223019ac2c4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc1d66060dac83cebbbc22d339cdb8f0c0edff6ef05e61c050084c53bffcb3c"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end