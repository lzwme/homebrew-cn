class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghproxy.com/https://github.com/go-task/task/archive/refs/tags/v3.32.0.tar.gz"
  sha256 "04666e5f763af99bcf98c6897d726f483165a7ed04801a35ffe1e55f78bbfe2f"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "535fde105a90e6a73e9815f3b0a3e3780ce021501d5c97fb93a7c9fa0735ac9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d91630745449bf944075517fe3231183e3e87c07f98ac6b00db9a245439c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3ca0a48a59d2287507b530d3c60fc3c2d212d0ea55f0413722e0a66ec6d277"
    sha256 cellar: :any_skip_relocation, sonoma:         "75eb21dfb4abfc7fbeb16459989d00d6314524cdae913abc9cc2b2d22c10d28e"
    sha256 cellar: :any_skip_relocation, ventura:        "54063f4751a3112d23f35bedd88fc5f769e3a6b9b6cc787fd558388d4f142a54"
    sha256 cellar: :any_skip_relocation, monterey:       "9176af57e2d923289b3b57c3c330c765e80daa361c7503126b79d6e450aecae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae9dcbd6421537affa1fdad81c7226b35602ea4d26cb26522d6418344cd828e1"
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