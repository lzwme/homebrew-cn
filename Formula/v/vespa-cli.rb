class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.326.37.tar.gz"
  sha256 "592a660d9ad73cb877954b01bd55d202d3fbdc5d9ad86a6418c14b5ce79f7e61"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd99188f27849232708e5e801721c3e667911a728451bbe13796ae382c0ce4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dc73d7cff33e35c8a6488645d6f1c9c8f6efbd85beddd0d5a1b7b2e7ca0614e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0289c6528dac16c380b65de17f57b63c0d48662a562a9b3e6734d9081902509"
    sha256 cellar: :any_skip_relocation, sonoma:         "e93057e7ff00c4ce518d653c3da03303bbf2808dd4d6af8576f729026efb72c0"
    sha256 cellar: :any_skip_relocation, ventura:        "f134bf4092d3bc895ce6261fa3ae7f838a9b9db818418d6853f83fb2217c9f10"
    sha256 cellar: :any_skip_relocation, monterey:       "d8727a9e83c026c45c104753d822ee05f33b7dcd199a801a454d5bb80bbb7680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cde0628849a8051e526b39f7178c92ec2250b26362b6b1be8416155b22e6d23a"
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