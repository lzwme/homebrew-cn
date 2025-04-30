class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.513.17.tar.gz"
  sha256 "c7659c0c6bdb4c3550850d5cc6c3bf53b581c6cc53336700710fbe4f9a8d8f9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d38ffb340892aa943affec0dcebd8cf05507aef52e9348b47241bc285a13c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a9aaf6ab1e590015fb3105c10ced5abcbff6cc72a41c4b43d1b759a03f40f16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85d5f6dd8390a8feef41c258603104a6ca4dbca614c2b51bc78a18dd7814c976"
    sha256 cellar: :any_skip_relocation, sonoma:        "d106fafb7cfabbc6ffa5558f273029ee735a43766d6b5b268c469c4487adbce8"
    sha256 cellar: :any_skip_relocation, ventura:       "faae7ee918440daff83b31246a37e89b69936bfcc4561dd0d3d654d0c1608918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1660280863545c96d948aaa2b42e5d3bd83c89a39282998a8f5d86b20d9763eb"
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