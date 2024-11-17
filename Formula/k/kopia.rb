class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https:kopia.io"
  url "https:github.comkopiakopia.git",
      tag:      "v0.18.0",
      revision: "68c5308e4ec5e73286a0ac8cd5b49103538c402b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f666a55f2ce0cef65d0a1fdfc050ad9f8413ee8a9a2605327cbe26c420a32adb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3cbf713572ea328e03ff249beb918714e53a59b5bffecd8608bf7250cf066c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bba1d271f080bf6636fe42fd77513e7736a7b77dde3eb4576d4a99357330db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a258049cb3e0ec3de06fd34dd937505cf5dc842c3b4a4b9ee4a5713a37af3a"
    sha256 cellar: :any_skip_relocation, ventura:       "b870f74304348d6899a59ca2dcad157a881a54e79677f8fef1ee64e75ca4450a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02ce80d8b1ec8203571b61b7f54382c1990db27203d5c5183d8746bf865ee53"
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