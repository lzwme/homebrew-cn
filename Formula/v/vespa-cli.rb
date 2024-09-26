class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.413.11.tar.gz"
  sha256 "afdec89273cc0bef8f9d8c879817e75bac5c5588a55f4debfc62d24b57a838dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67edb7ba4ac1f530bf8c7244cd81d430be78171dc8dc048f2570d949ece132d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83fb6aaad5844e20d78814134d9f4226a53d3cfbaf3fbf68ec496d4d41294164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd2f4a23028e1232eafbd29117767ce199f20fed37ccd54324077fa2e87236c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c227640ae2caf58da21d3e2861b3b1acfb347e2a8d3539ec638adc2859247160"
    sha256 cellar: :any_skip_relocation, ventura:       "9e58d1617a58534e3279966c59464d980bd3c403df7fec74a7406c8f8b577b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc4389c202fa6ac4eee3c74f48968924b2de8a7c4c34ea636f040147f61d762c"
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