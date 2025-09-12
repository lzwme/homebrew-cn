class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghfast.top/https://github.com/go-task/task/archive/refs/tags/v3.44.1.tar.gz"
  sha256 "d395eb802cca3f3f4b90e4bf504b6bc01f676f466d0bfb9e5045457bc085f516"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27cfb26fed2bfdb48d772ecaf77c090fbb8fc1eac9da202d73e6d57b66fdd176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b4156e3fd69f3be6cdd3f90b3889fc1cb2793e36933a48ed3e37685d62350d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b4156e3fd69f3be6cdd3f90b3889fc1cb2793e36933a48ed3e37685d62350d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32b4156e3fd69f3be6cdd3f90b3889fc1cb2793e36933a48ed3e37685d62350d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8988a816111046476175ab4476276468226f32bc3ca9aa55cc2af3f369559ac7"
    sha256 cellar: :any_skip_relocation, ventura:       "8988a816111046476175ab4476276468226f32bc3ca9aa55cc2af3f369559ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd4f4f733c6dc36757f9c9274c8f718eab80145919c1b18346ae17ce6cc365e"
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