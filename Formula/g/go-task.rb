class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghfast.top/https://github.com/go-task/task/archive/refs/tags/v3.46.2.tar.gz"
  sha256 "753ff03f1778d4a91d23b9237011d115d6b1be95796d3863493ab962494605a7"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f4cacadc3a98d3a1f01a481d43a317eca6a140490df32530612825e3ea55de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f4cacadc3a98d3a1f01a481d43a317eca6a140490df32530612825e3ea55de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3f4cacadc3a98d3a1f01a481d43a317eca6a140490df32530612825e3ea55de"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6cad6ec7817ea3595274c16c3db7dd547275a8cadc856b35e4ae9cc8bd54771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b10a591381fa48ca13acd9e8f86dcc146ea41389db1a7856d322df5862f9bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e70360135da4e43094da198f613ec440d24708ab791f775e4e6d38a80b43de0"
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