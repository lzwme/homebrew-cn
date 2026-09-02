class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.748.3.tar.gz"
  sha256 "8b788c1621f62339a67159155182bec9f61eb57de6c9c311f38ea562fa400911"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c5170999cb0c0a3a7d73cc32e6c4993e4ea9ead5d297dc22dd8f1d021fc126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bc1bba9f79866bb5a1f6fed1cf22048f78a2ab79b668c0d47b13d69f45147d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5927c919634176af3187d1446481438d41f69a7cf668835cc1e1167ed87bd80e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b245969b0a89cc7ecabc132d06b7da67e1116f3f1895c93cd036d235464a0b"
    sha256 cellar: :any,                 x86_64_linux:  "1363da024a75e7f2c6572e9d1135f5c0a3cc51868de71588e5cb90ebc86426c5"
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