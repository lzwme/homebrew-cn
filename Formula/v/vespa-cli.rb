class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.346.21.tar.gz"
  sha256 "d7672344125eb415ae2ec0eb8f30804e85c4bdc0ee21d39f5f2a562551a95203"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fd99879f00d35ed21d87c638ab361cb6aaf1bb6a624746b84ced85b1edc37f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65cf5204b68924d3fb6f756d01afe543656d090d4cfc1047f7e99a8dafcd0ed8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07ec1117205004cc15c509eeaf28df5128f4791c19999a8eae0df6dcf65a0840"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e17931d2eadff1fcf457cb69169a0ff78d1af44d22ad68641ff41ee7d7a99e5"
    sha256 cellar: :any_skip_relocation, ventura:        "04bbb5d9ce69d8fbc2aa8d9b1a788151a162fe485464a16e057952e310d7f3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "d9bc03f4cc1bd759423e82aa5798f01672be25ff368582840c492ca8b0513265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e6ecb7773c395fcc388d5ec06e5ef5bb8612087b9b1a160e1176b1ae0540d1c"
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