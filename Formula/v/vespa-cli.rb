class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.360.19.tar.gz"
  sha256 "bc49298392755448dcd7d1be190b5a6306c6cb4d62bdecd2995ec831621bc5ff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad9e0ee974608117466becb2daca8e8051d5a3f0842f9dbe92fd11cfb420ccdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "224e7520f0972996f8741658f4a68573afe7047c4674af996960c6bebf0be06c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e97943b07100262cbaca57af042f6d56f4c267252027c2b570f7cac21ccf32f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fcf83eb697eacb2b9ac87b347952f8f8668b50334b62a3290174239ca9037f7"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4c5f9fa30f7ed735fb979c2742d3888d84a06a15700484ad2295a29677aa17"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7e881f5666ea118be621ddd9bee3be6a0ee3738627a8b9c4b02314c660164d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed727edea3572dec378fc8dbcd4e67ef4d8b202505af51f19a637f3e3d759724"
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