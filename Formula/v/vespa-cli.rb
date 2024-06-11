class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.354.46.tar.gz"
  sha256 "a2fcd45a7f74a867334524cefbea77e74db4e546789e9e103d5b9be1c0f24460"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ca2ae02258a6a4b8a7b5c0deb86ce60958ca7c51c085ede96c57bf426f76d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edbd5e57a8e235aa617ffde7af2c003d0d10c106711fe54a075d15624f03f55c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c526a033fd43ba34b9790f0907eb72a6d612c60a149ef381b363ac9ed46958"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb8e392c2c656337ed1d695ec617da3daf47f2fedc26caac50ae0b3ec9749996"
    sha256 cellar: :any_skip_relocation, ventura:        "f01f3d201cbbc2bf0e847ca6caa9e75cab64cfe959df9eb4d120d0be99c54056"
    sha256 cellar: :any_skip_relocation, monterey:       "908404d6c09d399dea253f2092d2c4f6e9036e0abd51c1c6dd5904ad51c69713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e90c5c00960cc3977ddaafe13c32ecb15eea8f372333e861054957ff5feb9f"
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