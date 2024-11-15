class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.441.21.tar.gz"
  sha256 "306de2303d649719130a89b4175f00e3a8ec9b0515cd68bb45f0eb8168d0ce34"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e63e73c5777dbf036e7205c882772fe76f3ef743cea3298c9d6dea75308b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebfef212f9c9ec80a5d9649513ada97b0e0bfdcdc1f6d1e27d5419ffcab330f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d4698a39c61074ff172d5918b508de1ae8263bcc2416655b75dc294160a2345"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bb1a1fb86c6614b944d4b6c94e43bc3b485f57da235d7ddbd39170da83ba429"
    sha256 cellar: :any_skip_relocation, ventura:       "f97a6a9df406bc7704bba54355855227375660a9f93cacac40c990e235f2cfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97fb452c64a4cbef4544fcd34c798398c8d85788404f5b9ac13d06c6f6835d75"
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