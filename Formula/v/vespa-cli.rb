class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.416.42.tar.gz"
  sha256 "6e31cc35a537a3d1cadf3dc09ae15eedf5912fb0f967e2d48aee93fc2fa8192f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21da1bf74e2d82754e9d48ca0e53664dbd6878d27a8a69fffd304bf3f3b74e8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e233122924c929c0a1e927e1af0696d23a9f8d94c46e7fa023605fbb030ee709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bf9f5590efe2bdd481154a7af7e7d203f1c55abc8c020469b546c795e2ee66a"
    sha256 cellar: :any_skip_relocation, sonoma:        "447984f93fc2dcc662796d756def5e3ff83fd8605d988b6a83968f5207036b06"
    sha256 cellar: :any_skip_relocation, ventura:       "c6e0fceb72fe64e362bc33953647fade4d5264eef97cb6bf4e087ca70e8f21cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b72c74b7a312f9a42720bd8764f4873424e92eb049b8cf8cc37566d765b595b9"
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