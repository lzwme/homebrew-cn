class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://ghfast.top/https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.16.tar.gz"
  sha256 "a3977f96d80cae64b37d439f6d40691cf70be013019a7363736530a613f8cbcc"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffe8e070210ff0ed8c22cb6189f7c1a09578f3827088fd718f0f810e45aea9c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe8e070210ff0ed8c22cb6189f7c1a09578f3827088fd718f0f810e45aea9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffe8e070210ff0ed8c22cb6189f7c1a09578f3827088fd718f0f810e45aea9c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9bbb7e94587e1a2db3f380f2644d97694f0427d09e18824618a4f3f05f08722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc340336477344eb0206820783479dc036ca2a223b009416b664dff2fd6acf94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f75ce062836a88b5a3d7a9550fa4ab9e1bd5df8b2b374bdfd7cf8ccee23397c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end