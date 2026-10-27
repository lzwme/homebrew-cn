class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "09a49e6f19de361444e6e5bf4ccc522a03b37fd9f6d317fd55f0316f2d11aa32"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21c2dbc1b734ae53fffdf4c3b542de262dcc8e35eb1edcbd3fbc80ba2a460341"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21c2dbc1b734ae53fffdf4c3b542de262dcc8e35eb1edcbd3fbc80ba2a460341"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21c2dbc1b734ae53fffdf4c3b542de262dcc8e35eb1edcbd3fbc80ba2a460341"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "979bcc3a4299849ba4ea0079ab594cab34cb312078d4a0de6621944a1f55f299"
    sha256 cellar: :any,                 x86_64_linux:      "1fbf835bc4f3b307fedc0fb1f737417f550c4d5a8c10ddd1194c1e77e3e330d3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghalint"

    generate_completions_from_executable(bin/"ghalint", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghalint version")

    (testpath/".github/workflows/test.yml").write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/ghalint run .github/workflows/test.yml 2>&1", 1)
    assert_match "job should have permissions", output
  end
end