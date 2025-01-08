class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.460.16.tar.gz"
  sha256 "8042f6d50ff5c99a766175b5206cc181abd0ca87934d6b9f43c3c0a36b3ac2da"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "832393e2c2f3e575302dd77afda661bdb48d292bbc7ce7aa7233e18d00dcfeeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "200d6a42a68c15f8ed9557419f0cb847976b1cf184a9734dbde3821ec3b9a654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24b0b81d6aff1263fa16b67c7ebf8238f1d2b40908ddd08f3a79db611ba1cc29"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3217adddbba38c2cfce632c55ec413c154d96c909fb21c5d81366e59f0c8ed"
    sha256 cellar: :any_skip_relocation, ventura:       "19eed6f05003fd54d5ed56eb0e1e2af1193d509809d925208eaacd2cc6a8aff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8725c3276096d84bfbd8f2be637d959b744b7a44b948db31bb6dce9a454cb076"
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