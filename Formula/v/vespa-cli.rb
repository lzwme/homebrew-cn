class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.636.27.tar.gz"
  sha256 "05ecfb769b6cd88cf1e0b1c3e16ab6e0d70f55307857517681472bc820d291eb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b7be310c5b6e4f99d2aa5ec817321cd6ccd97579abce1c396f4d8d2828f73c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969772a87099e53afca83963775c1b5e121f130ea528472f507f01e1248d5413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fdfcf8c9b2ccd18fa1abd5250d40bf40e4a9af671522b6e8951ed4f9db2573e"
    sha256 cellar: :any_skip_relocation, sonoma:        "20247f45eb2a3ac74682c07ddfd309a3a237a5530593a349b574fa94bb570e2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2748e87feb56fcfb694a6bd36caef8e2594eb5f928d7e4284db9b14f774b2b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e12781305c5a67f5717d3f6861d47754412287465d7b3db000c2f14e91be9f40"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end