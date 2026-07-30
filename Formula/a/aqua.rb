class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.62.2.tar.gz"
  sha256 "9c533de56b097ce4f0a31fb72183db2cf98715eb7320c4786d502a9281fce24f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c36c1e6435dbc8b0a4443b576abd664b96e1cf5c904306320edd0e91c4f1bb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c36c1e6435dbc8b0a4443b576abd664b96e1cf5c904306320edd0e91c4f1bb3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36c1e6435dbc8b0a4443b576abd664b96e1cf5c904306320edd0e91c4f1bb3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "88647d319b84fbe479c36dfca2b679fd10af0c7a45bf2b479c8aa184994479b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e19d8dde37e994ad91b46cb191d7941c6b6f2c177d144b2086fb68c385b6b8"
    sha256 cellar: :any,                 x86_64_linux:  "934062c662b43db3c7f71b30ce6a5290b0298198a6d10bf1fb03cb679140f10e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end