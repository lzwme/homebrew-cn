class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.281.22.tar.gz"
  sha256 "4e24415772f2e4caf732dca25c4c6082ed68d4cb850412d059cf29dbed7251a6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8692092c398c56bab306a892b570cfaafd9eb07a9074ee4ae4144f0041f52141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8895ea3d1a1cf4b4ee2be5fd2187243e36b48122773d8e686f73c130528029bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241c0fe346b5b5d4ba85c32e53e9c352c531b1593329bb66cad7780d9c4750b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aec9e0b5e15d3bc0f62891285fe5bda7da69d12665eb26276aa025bf19cd6ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "1baa03fd48fc7cf085fb04f49bc210a9641330ffc78d1e0b9fc9def524afdb67"
    sha256 cellar: :any_skip_relocation, monterey:       "93879aa618e7f82d917187050bd65348b36cc2200faf2c59d8dd9c8418f38c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9476c49fbe602eb2ef16b68ad58250e8870d9f86d62cea32065877593a7924cd"
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
    system "#{bin}vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end