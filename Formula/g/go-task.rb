class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghfast.top/https://github.com/go-task/task/archive/refs/tags/v3.45.3.tar.gz"
  sha256 "c72afa44e4e00f62e664d755960e7b8bf4d2712249197709c5585ca3f80f34b5"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d804f51f8c6521cac1b214a9cffb6e7f8df179f6282e7037077f13858c61ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d804f51f8c6521cac1b214a9cffb6e7f8df179f6282e7037077f13858c61ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d804f51f8c6521cac1b214a9cffb6e7f8df179f6282e7037077f13858c61ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c87c86e8cd2e233bb6ecfe48e057c8637eaf34061040608422335dd5a23a6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d4f658bd0cf4c653ec26ef9514a5ecbf2acf62cdc22752e06f294edaf3e6a07"
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