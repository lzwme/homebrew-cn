class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.341.29.tar.gz"
  sha256 "4cc219bb07dda480af6a37eaf6d53e8a2e8548faccd46b5c9e5e32c06187cd0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d09c22796d7333590e9284b7c785553676c626194d6c56246be2e964c6ab59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e2f9ddd9795722aec75a6ffda646d00e7b903b1799523e901c79d6178cb4a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bda683f39a2688c4b93384265c9c3ed478d2d7dd5825adfbd0667cb39c4cffe8"
    sha256 cellar: :any_skip_relocation, sonoma:         "05a73536c7669e981ea0a07310e37c1466720e3913964a6ee6e4c3f5f7eabe5b"
    sha256 cellar: :any_skip_relocation, ventura:        "a5b7b07fb4dbfa9fc7f15edbe1c244dc754bdf94d27210d13b20685564558d78"
    sha256 cellar: :any_skip_relocation, monterey:       "a43f21c41f5413d146f22c083db3d32143f6f48f4be15e6f6b29e0fb91b6c5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0bccf10cebb7fa244a93efeda5f96bcbd5f7b631035d51fedb3890d155ff177"
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