class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.194.16.tar.gz"
  sha256 "9f0ca07508404f1dbc96cb31b38031f736db064219a407ed72a260843af16f1d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96cbd7bdd73549da9e1b9c6a4c5952dbc47e56848c2b7bb5e81ea388c8ce49e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba16a6e7e92bcf3e29a307d084cf365f87de920d0b7c13f3f855d90606c69f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16165749d09b2142931b9f508403edbf7cdedbea1570b78a1de866ebee6fd086"
    sha256 cellar: :any_skip_relocation, ventura:        "6d437de3010f85f494cf5d87abec1d5a613c4b27656d94faf8e74ebc2044c4d1"
    sha256 cellar: :any_skip_relocation, monterey:       "e4ba2c453eefc637a38dac13206ea727fcfb761dbda1520680d60d4b1f193356"
    sha256 cellar: :any_skip_relocation, big_sur:        "5db26fc86cee69aa99598f0685b190636cc137ecfe243ef880826c11a8f25023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d15a3f92b083fe98ba8478704eabedc9b886a049d541f47f8082f8b2b0a2c6"
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