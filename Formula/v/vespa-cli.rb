class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.343.11.tar.gz"
  sha256 "7d67dbc25092ed311bdd721cf96d7496a45b05dab3a929d1fa1298fd9ab8a897"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "396f3dac599cf10014b24a9dc8d60899a4dfe6774d31ee64026cab6011300634"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24dc79bda3329b1d003c096d903ea98c0acedea226b5d75cb7d68b5883586b35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f914068049aeeb4df19889b7538d6172b094d46e0438c2eb4dd1c58f5156ffb"
    sha256 cellar: :any_skip_relocation, sonoma:         "841b572014092b70e0971fccf3c9f8829036bb4d64ca5a94cba8ef8f0a43353f"
    sha256 cellar: :any_skip_relocation, ventura:        "87a4079e164448d609ada0f1a9ac226e38c915d028c868445527ea102d117aff"
    sha256 cellar: :any_skip_relocation, monterey:       "1024a39be8d6a701ea0e03c350a12e474d4d2859ace347480e388c14dc92d12b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786c010333addefae2e6da47d6838161b011a660e1d86a24f5396293786de95f"
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
    system "#{bin}vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end