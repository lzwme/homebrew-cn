class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.21.0",
      revision: "af276549f79e8f7b98bffeacfcb9d87a14700dc1"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2412cf6bd2e216cd4eb39df6a87df14c6ae95a378f45514c1a61f6e887c24825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bde53ca5ef5dfc5317a8daac918e3991c2b169031f3766ad9d4f5308ccca899"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cffe8f2a27f9c11995f85244ab211e89f468ca885069a9f2c1ea0d96d363d661"
    sha256 cellar: :any_skip_relocation, ventura:        "2e89611fc5254852b5f080ef8eb48829ccf3d0caa2ba2e9c079088521c0db996"
    sha256 cellar: :any_skip_relocation, monterey:       "1be9e42c8a80971e1e8199a8b286daaaf4e730a75fae25fbad2c69a1243946fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdbef04d16426b73e7147040892e2a556fa0b8d9ff04361e3d28ff7253a0bf85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef1b2a91a39652d49ebada0b4db1a356195e715440794a7cef80338f1be3c6e"
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