class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "a25a631909eebaa5efa50475aa65898f470189854c6fb05d495bb9c582b3a6ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "213818305b7afc9c53bf940a1e8c5cd51925d948502fc904439bf650c70c3d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "213818305b7afc9c53bf940a1e8c5cd51925d948502fc904439bf650c70c3d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213818305b7afc9c53bf940a1e8c5cd51925d948502fc904439bf650c70c3d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb2f35491d6c5aa2b61b079fac948ba2d904de277763091cb1fe78e0ca13e97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7b8cf7d00fe2772ce2fce9d667e445d96dbde2a26e2f31d199741ac119e7cee"
    sha256 cellar: :any,                 x86_64_linux:  "33e60ea25478a013c44686654bbd8c28776efad2509502ac156d96c6288af7d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end