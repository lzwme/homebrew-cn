class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.356.16.tar.gz"
  sha256 "18eb79c5a207b52acacc9034165af3573e5ec545320cb12abbfa692e3e43850e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17ad4d5e525c4749a782490157656f954c3acab05d613a54580fe1887d8276fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d283571c5ff2e348238dee8122c12f7e96dddd326b714f0b4e55afb359ddf82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "813779a3810968a4e52e9c326b71e5a9448e88b8c4fb3dbf49d7c8c32cdeade1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2800bce277ad92407b1b856bf34ac8dca24f8414c185ea116e5a76a78c1161bd"
    sha256 cellar: :any_skip_relocation, ventura:        "6139b85c8edfc025b7ff4fcd723a77696fd394603d7179e84b4905db42804ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "b54b772295e115f83fac20be6f85b99b88fa459a0074be70ed499c4f2b5f2fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a90db3edaba2ecc6c652895866e440e7a535b83563a565fb24ab630687b70fe"
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