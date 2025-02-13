class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.478.26.tar.gz"
  sha256 "6de73c3e6ad3453841f4350e19d2f10cd8be2cd729184e47052e615b47688f12"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36fb1993c792a2841e9f07d757c93116058f68f5eebd142d3341b5d0d19bdbcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f3025edb3e708e68b595ebf1f06ab8baf6d5198d6178ccb1360243f51dda9e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2b735901ca44641eb98c36c361f104389277baff688be847b290fe28d8ac176"
    sha256 cellar: :any_skip_relocation, sonoma:        "317769b3804221fa200d6ea8cbd5a61aa365c936ed967fdbe238261225282077"
    sha256 cellar: :any_skip_relocation, ventura:       "c180c4967a08f75be1a72a33e1202dbcab4e8f071ba9698d8493d3c47bb26809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b81b3b183a1887c057ff6cd6ece7b87735f3e30391b02f8a45194836c9c4df"
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