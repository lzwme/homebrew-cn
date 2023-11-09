class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.22.1",
      revision: "52d976beaea9ba8a5b0f09f90f22135b468c33c2"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2f2a53167f69facf4eae312e2f373e50f6e079d1f96e0b41d34a963c81ea2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "849933ac8bcce47f369843e9df2b97d438286241770cff7c190836d461b8b19b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b91698c73dccca03e1424b985f78e6fffb2cde34aca6371aae06cefa3005bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "2278063974ffa7ad6a6a26dc3ebbac7d0d6ab7ee45aa79b53eee7698d78fb569"
    sha256 cellar: :any_skip_relocation, ventura:        "d1ff4673217267f7a5da6755673e9f0c36143fb22fe8a0dec97b77e8c1d131e4"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0d4b4680ad79af5cbb6fe1a14ad8e4d6e562e125991d73e581b6ec935ec6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ab7fe5469e4abe0c2f28750ef6050a4ab3c23c17031b4543abcd9bb1cf8cce"
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