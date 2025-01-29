class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.471.25.tar.gz"
  sha256 "af54ee076605c06bfcb807efad4fd7a8ea639d55699bca0eb5296eaa64766301"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acac14630b18014ad54839ae75c1f2b24dcdfa3cd3f827840bd55bc0a53722fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a29cef3388cd85c99eef27ad362502dc8acc397377af531808bf3a71dbfe83b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1464ce325013edd64896600f0df0bebdcd4e21c21bf60070021ae942c4324bff"
    sha256 cellar: :any_skip_relocation, sonoma:        "550992ba6c45c64e6e16124b827c27a0367f6a8cd1d39b46aa44eb577a0e8370"
    sha256 cellar: :any_skip_relocation, ventura:       "96bbf62aafdb28615b57f73652f8d8eb7dbf2ad84bcdbbba653e0515219444b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5316873bb0c66a60c45e57b69a6811485ab80b175dd1e87c4843fb11cffee878"
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