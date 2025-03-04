class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.489.59.tar.gz"
  sha256 "f04d499751a7355e6458a807609be3e3e8476220dc223e0fe477a8c50175cfbc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1f109690333ddcdd71a78bebb9fc080f6860e876d4a3505c6964ae09132db9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b1ce5b135f97645fbaa7fc9dca03bcfa03de5c8def4cf6e7ee7267ff8a9833"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "920b9c47ee624a1add53a477121db9f88cd1c472c2a52029f5d0d26333c12dd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa97533c4fbc119a129a4769e0a39aab3fd5d06a35d29d8abc2a71ffd3bf208c"
    sha256 cellar: :any_skip_relocation, ventura:       "1e4a0eae1603b869c1edcb557632aedf83238ed9d53b01cf9b68dc5fd84ae6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "211f50435fb51b14aba52c2c0f784a4489a39c128c13762df50093a54e23a4d7"
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