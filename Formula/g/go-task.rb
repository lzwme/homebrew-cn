class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghfast.top/https://github.com/go-task/task/archive/refs/tags/v3.47.0.tar.gz"
  sha256 "4a530d91720dc05f145524041f997f068fb178fa92b5f54b8aec2b7cfec6b272"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e69dbee515a813df97f06181e6398240c91af4d65f49ef4a99d57b3864f1c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e69dbee515a813df97f06181e6398240c91af4d65f49ef4a99d57b3864f1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e69dbee515a813df97f06181e6398240c91af4d65f49ef4a99d57b3864f1c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "90e3c1648626f593dee1d33190583fbcca7cf72936358ef55ff1791587cddb89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "636d1748986327014507c6e4181511f3e5f3c048f37c4d3da2477ecc5dc33cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d09fbc4d64478c0119f2bee081bcb6bbf61d1c5164d66933d59ac73b267ee9b"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task --version")

    (testpath/"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end