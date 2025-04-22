class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.43.1.tar.gz"
  sha256 "59e0122d5e082e7a22d3f1a981eae1599ed3e69478d367fe486f7d11d5e54be5"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82fc7bf5056330225e5d263b7ac86a9fef0b222557f23f8959aed02456a38cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82fc7bf5056330225e5d263b7ac86a9fef0b222557f23f8959aed02456a38cc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82fc7bf5056330225e5d263b7ac86a9fef0b222557f23f8959aed02456a38cc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "24e0a7c435b349eb4e8176219b11a5e24e35579715e5fb10e8681fb622fdcbb0"
    sha256 cellar: :any_skip_relocation, ventura:       "24e0a7c435b349eb4e8176219b11a5e24e35579715e5fb10e8681fb622fdcbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4361b40141237422f2d0bf6c1cf48108b1f7d49ed72fc2e5a07c1d9345e1db8"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgo-tasktaskv3internalversion.version=#{version}
      -X github.comgo-tasktaskv3internalversion.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"task"), ".cmdtask"
    bash_completion.install "completionbashtask.bash" => "task"
    zsh_completion.install "completionzsh_task" => "_task"
    fish_completion.install "completionfishtask.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}task --version")

    (testpath"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}task --silent test")
    assert_match "Testing Taskfile", output
  end
end