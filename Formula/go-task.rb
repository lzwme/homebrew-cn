class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghproxy.com/https://github.com/go-task/task/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "c027a9dacb586e4b168300039629b3572a7050d699780624dbfe31ab15ba4b89"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40deac404c30eb31267301e1083685f15db241d0aeac15f4ecb77f010b3c00f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40deac404c30eb31267301e1083685f15db241d0aeac15f4ecb77f010b3c00f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40deac404c30eb31267301e1083685f15db241d0aeac15f4ecb77f010b3c00f0"
    sha256 cellar: :any_skip_relocation, ventura:        "6ae87c1fe8fab48548e7ddedc7b33c6446da5583f60dc300306b2cfb1583638c"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae87c1fe8fab48548e7ddedc7b33c6446da5583f60dc300306b2cfb1583638c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ae87c1fe8fab48548e7ddedc7b33c6446da5583f60dc300306b2cfb1583638c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bfe7d9269bea769ea9aca2be5dbbf9ed57efe3926e1005e33a7c9f62f618d32"
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