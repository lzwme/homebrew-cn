class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.526.15.tar.gz"
  sha256 "eddcdf08538c2e74cd4406817b4d81c568170430e2bcd4f82ccce7ea10938d10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59cb11ab7a1c28c239ac94f562f613e4ddba4b25c73d633f81d69734bb16e769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f380c7f9033d70b803467dbca2907b4077234c1d25902fc5c7ed6d451f90126a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea7148e13001900ead28405ec906850282280270c88963a1b92248dca75d1084"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c77beeeef6378dd0254c3eebaf7f0d1e553673eee97e4a448d37cccdbfd175"
    sha256 cellar: :any_skip_relocation, ventura:       "ff9b5cdeb7f403bb82b75ff6d3f90372cd474a4e218585a16a1202ce5d57c738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ad87af526fd7f8f357da5e108b5c513b4056ef8cd0fcd620c0531539ddd547"
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