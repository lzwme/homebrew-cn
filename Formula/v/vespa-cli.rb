class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.338.38.tar.gz"
  sha256 "697dd0884ec48dc139d340533a56ad8c0bc162de9c1b25987c4c3b88b17c6ee3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8bbb79c19ee5f9547cf2af236459839fcea8745b65db9dfaf3a1151cb68d916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7408efb5320219e5c815a39ff1a9e0b1350502677bafa9f4dbc8ce32e4dd7b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03efae36f1088c6446288b75484660889889be32d590d6cd42fc88983b3af849"
    sha256 cellar: :any_skip_relocation, sonoma:         "2549e2b2ba943d508336655ef3b4bddd8206187158bc375fd94e074b5ae65729"
    sha256 cellar: :any_skip_relocation, ventura:        "4c07cb245e49bb714215b08a43bf7542734f76fc456bd3372ee4b96f04270bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc28ffe8c79edfdd366af5cbfe143f7b062dd5bca57e83005526838c86982a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50aa97c8981b466fdb9743776251bdd55e7e391ec8a1adbc96edf86ed49b00ab"
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