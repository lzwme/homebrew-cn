class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.209.11.tar.gz"
  sha256 "965aa394f216bd696676729203d3e792b96a4e358e1debad85fcde1f8af59a1a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eab031555c8be5cf3be362b44fbfe94aca96681ad92da0a81c5cdcf109860683"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f327abe307e0bd673e8f5e1674eadaaecc2de4db0b68d7d3de2cf6006d6355e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50c310f4ee7110dd11ad75b2cce70d1052da2b040141845aa273309b5c2c2453"
    sha256 cellar: :any_skip_relocation, ventura:        "10181635eaa464bec1883ebfee78989417914ef4776c40ce10ba0c5746f2f299"
    sha256 cellar: :any_skip_relocation, monterey:       "23fe3cfe339a0998ac640e9455f332cf5ebe977e575e43eb347ba0783e84960b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1e7d4027251006c1f3c8362920cbc4d79c67a891f502ebaa7b7de0b890237de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b0eafaf921651e4a7b149a8b5446cf62918710dbc519e80f57455b93ae668b"
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
    assert_match "Error: Get", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end