class Ain < Formula
  desc "HTTP API client for the terminal"
  homepage "https:github.comjonasluain"
  url "https:github.comjonasluainarchiverefstagsv1.6.0.tar.gz"
  sha256 "a60ce846edc6f8e5429c3cf14faf57f170b757c6ab13d8f36d64235a1959e6c8"
  license "MIT"
  head "https:github.comjonasluain.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470ca30ee09a8e40745f90086841c36f4efe34acdd7c7398089a6a6597314bfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "470ca30ee09a8e40745f90086841c36f4efe34acdd7c7398089a6a6597314bfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "470ca30ee09a8e40745f90086841c36f4efe34acdd7c7398089a6a6597314bfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9299bcb45b88a76fa588d7352925a379b41cc6cfc0d23f4c38b80903b2391bf5"
    sha256 cellar: :any_skip_relocation, ventura:       "9299bcb45b88a76fa588d7352925a379b41cc6cfc0d23f4c38b80903b2391bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b63dff05d2c4e4c322a6f4213271cf5e5a80d9a55d8a0cdca5dcbf3bda87748"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitSha=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdain"
  end

  test do
    assert_match "http:localhost:${PORT}", shell_output("#{bin}ain -b")
    assert_match version.to_s, shell_output("#{bin}ain -v")
  end
end