class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.694.53.tar.gz"
  sha256 "0f124fca07867bb483d0afe8a9bc8f327f5034fa6b5d4907ef8c726ed1cf78e9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e08abc952104a70e8285ef36bf58b45fbfad885e270853df8f2e8a77fc1553c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b271445094a3512dc47dfa6bc5256089ac8e5f3f3e75a7ee111c88ad9ed2dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d70fb468fb985ebaa3ec7c954264b25795063a9a1ed502364fb6221a866eb27"
    sha256 cellar: :any_skip_relocation, sonoma:        "1500d497e97c89d30f6d0fde3410666c6f4418d78c7102a1d9bcd7cb68ee7dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11add95d37d0e9c4594a141df32b0cf1f7f9a1ad7be773680caf90b60661f3ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5d3c98baccf71ab4e39db25d8ba4b4df13cd15d19b1e05d41d1949da669868a"
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