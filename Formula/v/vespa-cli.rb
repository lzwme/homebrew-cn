class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.503.27.tar.gz"
  sha256 "3120eeda0e8c91df292d2a8bd5fd03b8e10c70a9fa84c88fc9e010a699526ebe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f03400e8446f9acfef36445b15efef2dcdfedd0d918f5593cd14fe8fe39a027f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bff7d24be18e32bf76413681c844a7ead55f013c44d7c5b5314c623e292c219"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6aa101ed50c615e5df8127aadb16e2282dccd7e20a2b2e17813516b8ba7942c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d7743b6e857bd22ecc107505b6fead4c21a46d2d3b2e1a396ed43334f253c86"
    sha256 cellar: :any_skip_relocation, ventura:       "96d37495e5745c684fc7be78bb063cddbefa014f3afb681eca49c27469f7c28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a33da427e345b5341c70c6a266021486636f5745209ef7117632054a1f6eceb"
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