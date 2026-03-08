class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghfast.top/https://github.com/go-task/task/archive/refs/tags/v3.49.0.tar.gz"
  sha256 "6b3b74dbfff7493a157b8edcbac5ee4703a2711031bfa49a9b5bfef419bf81f3"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf3bc4904770154e6700954e6606f60d64e2dec03203b1f613d670ba26d870c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf3bc4904770154e6700954e6606f60d64e2dec03203b1f613d670ba26d870c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf3bc4904770154e6700954e6606f60d64e2dec03203b1f613d670ba26d870c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "026e2fd554699335997dca22f5a77bf99d4c272f11e06667400714a737481759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180acbe4c9d32711f0669c5f1098c1cf006f42bf234072214be48b432614bb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8120013b17ecd0a0fbfc0e9ae21e0579327243d5c2839da582a114f38005fea"
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