class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.17.1",
      revision: "272f18d877a3364381ff228863985d0d479ec518"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4438acce6b8d00e85dc63a0aa6f77b04d42f0ae9f2c2992c9528aa76decb9a83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4438acce6b8d00e85dc63a0aa6f77b04d42f0ae9f2c2992c9528aa76decb9a83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4438acce6b8d00e85dc63a0aa6f77b04d42f0ae9f2c2992c9528aa76decb9a83"
    sha256 cellar: :any_skip_relocation, ventura:        "9c785e515bb9be0f8465a67cc915e28de814ed2abf8e321c693766c3edbb2227"
    sha256 cellar: :any_skip_relocation, monterey:       "9c785e515bb9be0f8465a67cc915e28de814ed2abf8e321c693766c3edbb2227"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c785e515bb9be0f8465a67cc915e28de814ed2abf8e321c693766c3edbb2227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7318775f3b8cf005ec5a1ced99482fcae8d5d1dad093abd8474be40644f16d9d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end