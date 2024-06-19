class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.358.34.tar.gz"
  sha256 "9cf0bea20943d375133399aea54ec518c1ddf7aabf99f071d0ca183d3c2b7bb9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8d74f90730c5cea91f15818520c9fdb23270d4839ffd517e5d46d8749286f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb9e027180a8f00a1568c8eef3d1a9a7fe24ea641e2577a6e9208336d44a7d03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af718b98db3d71aa68d69cdcec0b445bd8f5455134af5f252689cf6d502ba37"
    sha256 cellar: :any_skip_relocation, sonoma:         "67ba8875e84e2dc6fac03f9a42cb3a6b9ad7f61b986ae12f3c5f00497e734d23"
    sha256 cellar: :any_skip_relocation, ventura:        "6f82fea702912ce54d63378451574d78e25f1a1ffeea6a38d36270445c8be129"
    sha256 cellar: :any_skip_relocation, monterey:       "24763b3a7b31968419cb866e19a10cb3752560fc667926e42cab4f3899c2c79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acb71773d93407db440d8e66c789c2c042da12305a32bdd7a2268130a0a2b672"
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