class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.404.14.tar.gz"
  sha256 "30f74a81eeb4cd7e2a368bfcc66ff8eb2eec94d56c498a24b726eae04cb29d0e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ec4c4fd4b320f411554017c371ab4e7b59b95e6ab821289a231fca9b14a3af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdeeac587ce04dabc8c93f837dc812f714dc998f9cdff716f8052af2f8b74d15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4df406cefff7d86db95db4d72246cf402dc6fba78cad0acad64ac9c825d24db"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7d82fc9bdc5d9745cf30e965bd23f6e1a6d57112d4f120129cf0ba7e9c47fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "d3bb40e3d8dfbc7850e2038ba5bc65f57bba23a20d34d20906768bd3a0db6da4"
    sha256 cellar: :any_skip_relocation, monterey:       "62543dde57bcc308d2ccc3b56be5d7ebd7abde48469b9ce6fc225d093d311339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b731e0fcfd4a15075e5c353039b40ef7d765a8e2b44b021e97c4de3757be70"
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