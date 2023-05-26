class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.167.17.tar.gz"
  sha256 "be9d5bf9bc1eed4a947ea05aed77929bec9b615cb9ed2c4023b5fcd37a6e0cd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68874fb536907b6d04458997b7a35c4161f95104fd68aefd43cf23c42047e064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf9860c34a0eb5815293c44e0f7b0ee82361cc69febb9769330bb3ed4d780c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a71ee681a1ed8b98ad98f09eab73e1b412961164563c46503b425d2b445bf07b"
    sha256 cellar: :any_skip_relocation, ventura:        "094aba560791a31e8f17374887b3424fdd2ec6a9e4d08b94afddf4e4107cf83c"
    sha256 cellar: :any_skip_relocation, monterey:       "db5414ad7ba3b566fd80dbd353014e394b9b0f0e2c0f24481efe8c90bf4983c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "aba048a2e0a1c1add5ad6c95b290f6ccaf2d9c2b70f90eae8c0e6348398b43ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec2dfc549f3cc05d063617d3f2d4db98c2397271229d809c26ef9bd32c289e9"
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
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end