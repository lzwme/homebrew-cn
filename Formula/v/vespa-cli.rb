class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.502.19.tar.gz"
  sha256 "718f452eb11d778cd85af4bc2493dec1c397d8b70bd31da7b6bcf373b8f50b86"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b87b0cd18d6b4060216012cfce132ad80e6b4c18a28f31bb4caef812af0ddd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e93e05448b5741aee07658643f67f34f937edde3885c10e2267af3f01dd22b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dddb63fc474098760d90b4b7fc252f975439e8de3bf01d5280b6ef869104aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "175da0e7bc0306a7e56c262bd04efc5adfd0e70e3eac7ce9488392742588789b"
    sha256 cellar: :any_skip_relocation, ventura:       "4e0578aa5315f7b5bf3e6c274575af71599508547d0684dabcb98c9006887def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f39628bfffff93e2c84f0f855dd5fd6bbb636a22b80d2c2bf97091ee80ed5d2"
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