class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.244.20.tar.gz"
  sha256 "367daa4d6d12cb97fe36e3d0d0d21ff009a08c5862e030aa0e3ad4929a228814"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa0124217a7e875af6b252c559d2841aded34d9fa594d5261e5a48f9b41ffdfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6258f9ae3a4477e5c2e6000b21b42a0d08ffac78dd375f6af0db9d39bc4b9260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd2b372b0b7a204b53d91700caaaa69aa48e22156246a06f620f7a151145e067"
    sha256 cellar: :any_skip_relocation, sonoma:         "85cf3883933ce21dec8bfdcde9cc200c48782792643f5d696da7366c3c959b38"
    sha256 cellar: :any_skip_relocation, ventura:        "5646082f05c9fb8a0a3265a43d4054aac6a58b4546437e0c523078538bb72a97"
    sha256 cellar: :any_skip_relocation, monterey:       "8c42b5b6c302a36df1a7d2c0d7510baa86d443ea13494f46b514a86585183986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d6b8b9844cdfbb27c5ccd66a8605e05bab66483f8687f0a1b709a1420a3827d"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end