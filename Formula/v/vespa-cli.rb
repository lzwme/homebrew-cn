class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.501.49.tar.gz"
  sha256 "19dd067d736e9255b09500d377c86dd8cf0d456fe15c2f74ef44e4c8f272e44b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711819bd866f3c8e858debd29bc18beca7ae6f4bc5973b4e6996284b35ef7bf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c6b40693b3a7ab0ae0b84443cf8ddc2adefd36c2479502a9bfd88cd6cc4b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08a13e8c513a38fe6908e5bc8633368957955b92c445bb0a550fde1481a7d311"
    sha256 cellar: :any_skip_relocation, sonoma:        "781417853d862d82e5072b6f33254dc32d7e9e0fd9d79366a464b642a2fbc6ca"
    sha256 cellar: :any_skip_relocation, ventura:       "24f2e9993271f6b60f7d30608e3761ed3df30e97e92efd29bb5f15f1ef3b2b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4a58b40406580e249fb59556b33c43cf3c29ee6aa4d2407f08453d8acd059d"
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