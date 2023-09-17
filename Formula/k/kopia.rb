class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.14.0",
      revision: "64a0df6f4eeebac3cc04518d2276ce4f665d4335"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7a1781f4e002b38fec2b71662fb28451cf77d88ba2d22c3431d07d95a0cb7b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fffe1019636b76002d19e909847d07e2cbc0ac9a8ce2d6244c6e5285cefe62af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfe3c005fafdaf1da9a2724fabc3f3f4135c037619ecece90f658a28a056f83"
    sha256 cellar: :any_skip_relocation, ventura:        "dc2e7842f595bc5b31c507ee7290263f4c2c2ac31a7a38d61677fa8b0b7d1319"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7e16fffb3753c31887e4a343055c0156254e0250c9dcd767048f6aca534496"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac9992246bfbce42406d9d5355da080648dd53fecd8066a828611b0d373ea249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7743e1227403d2994e2deb0fd543a3254f3ad29c6e4b89f3526d5d8f320758e6"
  end

  depends_on "go" => :build

  def install
    # removed github.com/kopia/kopia/repo.BuildGitHubRepo to disable
    # update notifications
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kopia", shells:                 [:bash, :zsh],
                                                      shell_parameter_format: "--completion-script-")

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    output = shell_output("#{bin}/kopia --version").strip

    # verify version output, note we're unable to verify the git hash in tests
    assert_match(%r{#{version} build: .* from:}, output)

    system "#{bin}/kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_predicate testpath/"repo/kopia.repository.f", :exist?
    system "#{bin}/kopia", "snapshot", "create", testpath/"testdir"
    system "#{bin}/kopia", "snapshot", "list"
    system "#{bin}/kopia", "repository", "disconnect"
  end
end