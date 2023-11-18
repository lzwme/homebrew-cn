class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.260.15.tar.gz"
  sha256 "fd1bd958e77770928751cf06b1f6d15ccbfc86b0a57bb58da91c10efdee23fec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac284bb551eed19f747a9452cd201d04971986a6ddba2b4cf4e1228cf13534d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4a7b8b93583df158ecb2f3a8fe47faedd47384be28bc7e32b5c5e46e964bbe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16acc5c9b713e96407ba2487a38e1c023f6ec091e1e34289a8266b89e2ae300e"
    sha256 cellar: :any_skip_relocation, sonoma:         "37999e016614aff6700d29b7373ac11dc0a6b8dc17f5b5d637e0c812b371a478"
    sha256 cellar: :any_skip_relocation, ventura:        "d243b5165c26806cd039d325ac1cf930ea307b999139a0c9a3b36663f386a700"
    sha256 cellar: :any_skip_relocation, monterey:       "f618bde2a659034f8f78be3291eebfc6c2e5a955b3e5e2798827030727f446c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e62abac5c1d4e671914ec227f06dbf3b6e7604e99321f94e59df72e2050b8c"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end