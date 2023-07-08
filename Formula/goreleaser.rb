class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.19.2",
      revision: "b95fd394866efeb147769b49a469f88186606177"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb644d4a474fa4762f929ac7c6053f13c6a9d67d39cf7e042e4f2e6905ddb81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb644d4a474fa4762f929ac7c6053f13c6a9d67d39cf7e042e4f2e6905ddb81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbb644d4a474fa4762f929ac7c6053f13c6a9d67d39cf7e042e4f2e6905ddb81"
    sha256 cellar: :any_skip_relocation, ventura:        "7a34f06863842e38167d7fa3c46b771722c34e3d2f83064a36ff0206acd978b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7a34f06863842e38167d7fa3c46b771722c34e3d2f83064a36ff0206acd978b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a34f06863842e38167d7fa3c46b771722c34e3d2f83064a36ff0206acd978b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3072439ad09264f7e799892135c14169c7f605207fcd831dba39f3cd22b06824"
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