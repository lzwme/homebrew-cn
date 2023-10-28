class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.249.12.tar.gz"
  sha256 "089888ad675e37552d60e36d1ae31215c688f974dc45d06ebc784eb29aef7632"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e807c6d9eaff4234a661f24f01eee53074712eb3586ae90ad7f765c87e0b10e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11104d4f6cbea5868b81f737ecdf56bd624dd54a846dbed08cb6515605822ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109aac3168da2531b87e29e13b033bbd7a2147a65059f956b3c5188039422347"
    sha256 cellar: :any_skip_relocation, sonoma:         "160d0909d32983f09732a541051c711f0c034f4eac45ca1ea4a1623f6bce18f9"
    sha256 cellar: :any_skip_relocation, ventura:        "3f89b73ec5872b7932746eefeb028206389136f2794ab7375b982cf3445286d7"
    sha256 cellar: :any_skip_relocation, monterey:       "16be490132acd491abd6640834d0e3fd799f98a1a518a7e69966a79333a2e9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca0ff12aa83b7d30f1e82251dadfde00ab5d8e709ff77113d886f17c4730b09"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end