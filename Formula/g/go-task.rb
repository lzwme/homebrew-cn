class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghproxy.com/https://github.com/go-task/task/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "e949fba7495285a4d1fa028b055068bbe98d1fa6ebcf462d922031ddb94613fe"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a0f04f6557d2739834c04756248f7868a436e1a8261326885601215ed142f15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73df4a68d42fcc70b2b05b81ff40ebbc62620bc1f81f6e8fcc81fc5c7422efd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7efdba6dacbdf285b7d3720da93cf8515e9c86a509c108967c0267aa0989b66a"
    sha256 cellar: :any_skip_relocation, ventura:        "4405114cf30cd3a7d38fb496c06496a27111f12d03ff057853e4b8524ee127c3"
    sha256 cellar: :any_skip_relocation, monterey:       "3944ed16197b27ee3185efc1117f53583278dd16da53a4f4e8f54dda7cca2154"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff94a6d813a577a9324a3350ac4bb458b99e24892a07e429c7eb31914166b886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf639850a6079e224bd5726b2ff6786557414a3f60d648962c94e25b30ab69e8"
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