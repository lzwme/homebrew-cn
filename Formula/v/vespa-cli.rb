class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.350.38.tar.gz"
  sha256 "8080db18dd7dc083468b80bbc89ef76457257b6f7d0a88e89879435c42cc972f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8010a465b52717e47cba5d3f9f7940391f9b9e69a4668eb9676f317784754f83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf27d02aa7cf68b6029da118aa3ea52921b661439792f1501e26838b72500da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cd38827b60cf090652dd60d72c5c9686d9074737e96de95466f6251b8de241f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a588be412d37a5fd53503545422335f33e53b836c442bc1240126c5c4b49e80"
    sha256 cellar: :any_skip_relocation, ventura:        "647097627cbc101006421662d825de1e9c4947ae6f9a507afc07b76458f27302"
    sha256 cellar: :any_skip_relocation, monterey:       "aab8ab921b69eff713ec9a60c9ee09e4d52c2ba30d591ddc15ee6b3bd2ad8e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1cdbcc67f8a72bd5bfa14fcd2c8ae279697fab200bdab78587805d475a71d82"
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