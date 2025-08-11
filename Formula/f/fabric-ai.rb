class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.280.tar.gz"
  sha256 "8facf1eb1477103eddc5984e8f8ae3eb8e53bd150c995484f0df2be1c991e17d"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3601cc7eb7238ffd9c1144ce9aa84a530016a6775fa82f5eb60aad366f4d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d3601cc7eb7238ffd9c1144ce9aa84a530016a6775fa82f5eb60aad366f4d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d3601cc7eb7238ffd9c1144ce9aa84a530016a6775fa82f5eb60aad366f4d6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "400820994d7fd47d2b42457e2bd99bf94632d6742d37998544fa5e2f83b93fad"
    sha256 cellar: :any_skip_relocation, ventura:       "400820994d7fd47d2b42457e2bd99bf94632d6742d37998544fa5e2f83b93fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "469a20c7989b135a841eec945b685e4001e198214949f696312eb1070f60f62e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end