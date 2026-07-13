class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.61.0.tar.gz"
  sha256 "af42b95a88f0749cd5ed414b205c714611d789b3acdd644326a2f9d4777e84d9"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "effeeec43536b8cc5a33aae6e895a6dc4c65535796cc731d15652bd60604388a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "effeeec43536b8cc5a33aae6e895a6dc4c65535796cc731d15652bd60604388a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "effeeec43536b8cc5a33aae6e895a6dc4c65535796cc731d15652bd60604388a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6f4aad5e4afa5939d8d34ac1ab5e7dbe04d504b08069cfa2bf68f3a46e14cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbda35ae89cca5fa7a49117e513d31ab923eb1787664001b17262fd437810499"
    sha256 cellar: :any,                 x86_64_linux:  "dcc251983018999c3ad5eccc4ebac69b378cf4111ffc14fd438e2739ae85bf46"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end