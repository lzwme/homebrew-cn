class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.16.1",
      revision: "ba2c93bf2036905fe00fd8482f293febd58c1a81"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e1980a33f472c1835e3bbcc95e64f7e74466d9f90de18785c24de6949488947"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e1980a33f472c1835e3bbcc95e64f7e74466d9f90de18785c24de6949488947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1980a33f472c1835e3bbcc95e64f7e74466d9f90de18785c24de6949488947"
    sha256 cellar: :any_skip_relocation, ventura:        "df87faf59a6fbd4baf779b4368c26b094a46faca1ad1b9274255cf38f31e587b"
    sha256 cellar: :any_skip_relocation, monterey:       "df87faf59a6fbd4baf779b4368c26b094a46faca1ad1b9274255cf38f31e587b"
    sha256 cellar: :any_skip_relocation, big_sur:        "df87faf59a6fbd4baf779b4368c26b094a46faca1ad1b9274255cf38f31e587b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac8021db957ac777e47065fa76891cc09f7d1439799de81418cc21df0e006ae"
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