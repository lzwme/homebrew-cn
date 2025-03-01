class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.488.1.tar.gz"
  sha256 "325594c09636280651e6c9173aa5cbdbf176d05bbd110dc12c7e882ef50c5c82"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac5ab1e8523e0dba636c589a11ee7dbe8fc729a462cb0f3d632cf0fd65f2dcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b2e185ab72bd12be22d9f5f4c3831b712e5c894628dc0815ffbb0135d40e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5ebe7106a906fe5a34a91881be57e6895cf1e03e70754084beac4515f0a0b0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "002417f914825063b4dca82a6d2c24e8d38dddcfcb137ae43899b331581a7998"
    sha256 cellar: :any_skip_relocation, ventura:       "4fb4917bde61c214a001797cb02c976a2dcc8a41db15236e80d63bf2af9bc9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a769036a8da63903ff39906e3f1c1969d904cd46ea2f231425c99d4fee3ca73"
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
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end