class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.617.12.tar.gz"
  sha256 "fd808c6ef243df5a3b390e65bd15a5c488de2b2fc683489a7f4b92008fb78a37"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "834a28fc60f8b8b117f375ad23a88c74fb266c5a09ee9e96cbfabdfc7ff4f84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85bb9a9ab4573de6d3d18d7be0ae40e64be2ee7543dbf07f9937685022bcc21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ffe5c11172b511d5a5f4932ce25e9bb3897aad63b8afc20bf3ac9f7f631208"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6719b77302d9ba014d04377adb2e696f34807479094df4ed05b6015d875b5a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf7dfcaecd95cca87f5963f9cdb1acf001c7de1a6e670a33bf1d76b32c5a5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f83f7d0093c0a41443dd211e82c681db5e40013ed338f745fd52cbcf8826a4b"
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
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end