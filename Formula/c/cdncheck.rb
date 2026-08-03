class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.47.tar.gz"
  sha256 "e807d23a8e63c31e6a125695d05e7631f9017daf28405573af50e59b38b85f4a"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35982a954c72dfe6eb942c764b0de27c8687c2ea5710570bd18e8d18abfaf4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fe906be7fadd3310fa0ae00dd020a839131959d0cd869df02a04e44ced6eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5381ffdcbcc253f8f441d5cd25ebf760832cc63a87361fe9de4d7362ff784bbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a908503ed4315a500bc7924fbe17a48027faee1c159ac4b233cf48dc84cf7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6caa78c417d99e56cd92706435d15a93f8d751f40263f047020569448bb32ac"
    sha256 cellar: :any,                 x86_64_linux:  "733ccda13a6bc66fa470768e119c4fc759ed4f39eaa5383881bf0e1f23ff17b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end