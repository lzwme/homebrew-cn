class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https:kopia.io"
  url "https:github.comkopiakopia.git",
      tag:      "v0.20.0",
      revision: "496f2d5d96a27e0913b59cebd9b2509bca1896f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349c46d402c0c9acd10e068c55f50092d4e5eab058cffcd5377de3c89c0464cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6e2d210c1719be69499689ece58b004cbc10b73bf3797ec72018d31c801842"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b38c0276fa919f864093510642289f0fbb70d3353d026cf13710bfc42a60753"
    sha256 cellar: :any_skip_relocation, sonoma:        "4898089f02c8bab400804cae09eccfca74331addc89ded75a8d8fec8e1f9b30b"
    sha256 cellar: :any_skip_relocation, ventura:       "239cc950865102b6eb843b4577e9aadc161f695416a7eca2e55a25dfaebee642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50cf99d95c1db9948b82bbe7eff85f108085adc4d4b3e33800a99b1cd757e34"
  end

  depends_on "go" => :build

  def install
    # removed github.comkopiakopiarepo.BuildGitHubRepo to disable
    # update notifications
    ldflags = %W[
      -s -w
      -X github.comkopiakopiarepo.BuildInfo=#{Utils.git_head}
      -X github.comkopiakopiarepo.BuildVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kopia", shells:                 [:bash, :zsh],
                                                      shell_parameter_format: "--completion-script-")

    output = Utils.safe_popen_read(bin"kopia", "--help-man")
    (man1"kopia.1").write output
  end

  test do
    mkdir testpath"repo"
    (testpath"testdirtestfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    output = shell_output("#{bin}kopia --version").strip

    # verify version output, note we're unable to verify the git hash in tests
    assert_match(%r{#{version} build: .* from:}, output)

    system bin"kopia", "repository", "create", "filesystem", "--path", testpath"repo", "--no-persist-credentials"
    assert_path_exists testpath"repokopia.repository.f"
    system bin"kopia", "snapshot", "create", testpath"testdir"
    system bin"kopia", "snapshot", "list"
    system bin"kopia", "repository", "disconnect"
  end
end