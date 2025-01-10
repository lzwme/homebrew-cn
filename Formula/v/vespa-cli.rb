class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.461.16.tar.gz"
  sha256 "cd6c5df3c87c9a20de3ff76a6f1de8a3f5d267cbaefe8948d19a6c5c8716c12c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedbb9f0ed38579ebdb241d1186aea849c58e0397f35b353f56a6a17d85dc13d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78b69f8b3286cbaca2784e2646c77292275573ecb66f33233fa2e56b2a11390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e9ebe8b0c8c05a5f503e60c3dac0d9a5dd086104055c617517b51f4faec837f"
    sha256 cellar: :any_skip_relocation, sonoma:        "db905c022c2071cb994bbefeff2543038e71651b596f400a42f085b9182f9c96"
    sha256 cellar: :any_skip_relocation, ventura:       "bc346eada7075f505661fb31370bdef1ae58f04895302fd3435febd2310dcc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36026bdb5169dc4937ab67c8081c0b5a8389b40190005cd1a65e3fa5254b638e"
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