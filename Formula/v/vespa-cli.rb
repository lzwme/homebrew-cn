class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.596.20.tar.gz"
  sha256 "696a630f87efcb53dad504739134c9bd3029fd43955fc2f1e3f398162cbdf956"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eb11da62a6d3bd490e492ea68e5942528f653d8139e7e042d32f044fae168c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7198c4e77cd32713187fc91303b11bee1b044a148c9967922f498c84b37ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "295a4dc32a864ce9174255eb4317607e2ea0581825ebccdb0e842b93718f9819"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab17aa93def5375c5b3046b283c8b444d073b9100841281ac678b01a1dfa7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a18baac11603ec70a12b29bbe597fa0a6e886a2dbd1612a15a8315694c1cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f134411f1d9eab41b6fae4c471189d56da337268b55372b829d8b4f47f5257"
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