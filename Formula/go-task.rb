class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghproxy.com/https://github.com/go-task/task/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "34b0d1ca1ef8b34246e9b3f9632635ae26fe294eb123a2d11c048a91a6401749"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9cfeb174ed3a4322c6a299a6b52b11b0e629ed8917f38b7bbad74abf8d0e3a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9cfeb174ed3a4322c6a299a6b52b11b0e629ed8917f38b7bbad74abf8d0e3a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9cfeb174ed3a4322c6a299a6b52b11b0e629ed8917f38b7bbad74abf8d0e3a7"
    sha256 cellar: :any_skip_relocation, ventura:        "4d9f1f7094e0a3e250169c20439083c9df1b79a3bf187f05d6738e736c518d15"
    sha256 cellar: :any_skip_relocation, monterey:       "4d9f1f7094e0a3e250169c20439083c9df1b79a3bf187f05d6738e736c518d15"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d9f1f7094e0a3e250169c20439083c9df1b79a3bf187f05d6738e736c518d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa176bf03b18ad00e45f463534442987c4ee748b6d2f842d67b11fc75699274d"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    str_version = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", str_version

    taskfile = testpath/"Taskfile.yml"
    taskfile.write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    args = %W[
      --taskfile #{taskfile}
      --silent
    ].join(" ")

    ok_test = shell_output("#{bin}/task #{args} test")
    assert_match "Testing Taskfile", ok_test
  end
end