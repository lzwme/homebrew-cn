class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https:kopia.io"
  url "https:github.comkopiakopia.git",
      tag:      "v0.18.1",
      revision: "b60cac48608bb8cd8fad69e535b5d351e49916f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3802612e84ea09a8ed7d98940bb69002eaa48603bf353f645e6a2b9130e6bb58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dd97e8c3b25916bf71748327b9bac969c40f659b20513decf77c088ed112148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a490015c568fc800356210807bfe2b17e1a78e48b6d76dab4f4eabc2e9f1756"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9d2c1c9c276f42c2126eee04bbe8891b5382847280caab414222397c005bf9"
    sha256 cellar: :any_skip_relocation, ventura:       "6cb9f647768618090f104e141f5704dfef8b923151e6d2785b80f703e326fc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0ffd68e0d086fd5af7e2d8f5d9e0ef7efcfd940d713a72849da9e0b482fa6f"
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
    assert_predicate testpath"repokopia.repository.f", :exist?
    system bin"kopia", "snapshot", "create", testpath"testdir"
    system bin"kopia", "snapshot", "list"
    system bin"kopia", "repository", "disconnect"
  end
end