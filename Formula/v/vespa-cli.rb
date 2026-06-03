class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.699.8.tar.gz"
  sha256 "65a332ffb1d65f6d46df13162ac9316c518afce6d238aaff8908ecd4173bef18"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fd0101c4a2e3ff0d2a658efdb1744a3751b6eff2b661bf7e1af21c930b4c408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8535622e2c82dc742232583b00591eb6577128693cb0a5945e3b64eaaa4d605d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ddf31ce19cb91f1d4b0ae70f66fabc7f14eb89adf21bf0b0731f2a0d227c8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e41b1893ef72b3f5feefc8a0bf55b6e912fe56136aa49318eb26a56aeb155555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ae01b455beb0f56a1a4b575e90df0a9fb82ded67a28b4a1f84c9b3667332a6d"
    sha256 cellar: :any,                 x86_64_linux:  "a28d1682844dbb0e265fb6071db0a9ed6c992835f422f117b9608ebce61af6d3"
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