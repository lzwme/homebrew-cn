class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.499.20.tar.gz"
  sha256 "a406f34b810bdc6caa37f1209740bd160c82705333ba84315e47eb796013eca8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07175d3e15d0467389e49090bf0cdd12ddd2a75dc2d8d7edff8c5642602f470b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f9224a23456216b25650eb01e296781092ebedd651f663110b825e0af2d415"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8e5515715efdbaecff7261f77515b7955149490ae76c08f00a7b6e75debaca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "07bc2f5792ffe26975b2f98155147b23b9f2d823a6a4cbb8616afe703d55e935"
    sha256 cellar: :any_skip_relocation, ventura:       "3b71c55ed3d47bb259b350605352d4f5ac5c4419e7a9f2e3b86bf7c22cdf029d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6e1ae9c3489f3d16193d36a63228fe4f9b3932ef2459d9a3447a067e7560d0"
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