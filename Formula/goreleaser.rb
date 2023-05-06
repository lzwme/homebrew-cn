class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.18.1",
      revision: "aaa9da33d5e72a0db4c1c815dc746249b78266d2"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa64e47e4fd7e08938848d0a60eb3897033a46cb7fee1d99ade2c6075b798431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa64e47e4fd7e08938848d0a60eb3897033a46cb7fee1d99ade2c6075b798431"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa64e47e4fd7e08938848d0a60eb3897033a46cb7fee1d99ade2c6075b798431"
    sha256 cellar: :any_skip_relocation, ventura:        "e296f22649ebf147f89073ac63f21381ba07a798d12c514edfeefb1ac908bd64"
    sha256 cellar: :any_skip_relocation, monterey:       "e296f22649ebf147f89073ac63f21381ba07a798d12c514edfeefb1ac908bd64"
    sha256 cellar: :any_skip_relocation, big_sur:        "e296f22649ebf147f89073ac63f21381ba07a798d12c514edfeefb1ac908bd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9fd4f24dd65b8f2952f49530ba8875dc544ad01f246196d18701fc79ff4b71"
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