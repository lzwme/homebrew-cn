class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghfast.top/https://github.com/go-task/task/archive/refs/tags/v3.46.3.tar.gz"
  sha256 "163b9ce6ab8afaf0247b60c742f7d7d66fbf1d1f64d91d5cdbf6d75b1dd54b52"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0e68cf301de022f888b50236f2a36ccfd1a0af224178ecf5660a4400237847a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e68cf301de022f888b50236f2a36ccfd1a0af224178ecf5660a4400237847a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e68cf301de022f888b50236f2a36ccfd1a0af224178ecf5660a4400237847a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa11f1b743d0fb409f2cdb40068fe4547e51444bae42f473f860b1dac7fe788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc2a2a2cdb0a3531af39993bba58a5aa1668a36b9e5c643844bee6f0dd842d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef411e8321c52be99134b201ee836013f14f34c39d4ba03ce2fbde7de125fbb"
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