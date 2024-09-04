class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.403.12.tar.gz"
  sha256 "2183f4ded0a130fb975dfa45cef70df34139be2b9d3ec4325cac14f3a6ea1f94"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd3002185f3ff432740b008259bd24248fdba1a4600297d77eb6f84085168659"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97f3509dcaa90eb49fdb4f583c37937a77c498b9aede3acb5da4d8cf6005bed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c1b68e72a840ec9b6d0e3c87dcc7ddc6cf9071616ca1d9dffb2cad8b35d03bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "003a988fd0441d0029eed01dd1666ece886cb48d656e0bfc063a793c4af09371"
    sha256 cellar: :any_skip_relocation, ventura:        "5a487f3c0346c181cf95f99b3f43a1429ad808e7afa16e10430b5417f2b71fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "c0802916b7c83494385bd1da8df4e0da94f4dc31503fc5bc96e8a4a17a56bfae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5043005ec71a98bafb443674eeaf9e1eac36cc3c455403e956c1131743a42df"
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