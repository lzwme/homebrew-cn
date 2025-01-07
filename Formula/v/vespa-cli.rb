class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.459.67.tar.gz"
  sha256 "820e20192cf622cf4be5e8fd576aee4cde98730e9adb381ad0c11f8f65ee08fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d385d302028258951393a77869da0ad6f0887d0adace97dd1deb423f7da2a96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30107593bf6a771e72dfb73006e7008530ec8aebcdf8d207f2c3bdfd929bce5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40e35f55945dd37ea75f91f33f34cc01533d72a13e5e8b534fd25dd9d1f07b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "25749cae89b2bedef2c99eeb61e53c19aa43eacc35823752803ad9aaa4c8eed0"
    sha256 cellar: :any_skip_relocation, ventura:       "6243d5fddb0eae67e8416ea194bb5c31acc8410d7d25f6710e09c9e118ad3fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451605fd03e58c96072e1e0cb4b0e12ca8a49429086b64a37af07c5c4891bc15"
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