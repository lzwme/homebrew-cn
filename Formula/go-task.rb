class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://ghproxy.com/https://github.com/go-task/task/archive/refs/tags/v3.27.1.tar.gz"
  sha256 "508b6612ca30ef4404aa674a2fb2a93e414eb5b06afe34e090145e70f0dc940a"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "496572eacdae84db86300f10c6a626290a7d0fa7bbbaadd25df5fb02f6131a97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496572eacdae84db86300f10c6a626290a7d0fa7bbbaadd25df5fb02f6131a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "496572eacdae84db86300f10c6a626290a7d0fa7bbbaadd25df5fb02f6131a97"
    sha256 cellar: :any_skip_relocation, ventura:        "d262c6f0ea7880423340460858a2bdda94aa70e80eed06670f3c6089e72455d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d262c6f0ea7880423340460858a2bdda94aa70e80eed06670f3c6089e72455d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d262c6f0ea7880423340460858a2bdda94aa70e80eed06670f3c6089e72455d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4486825fe7489fe617e7af34fdb1cf19a86685908186da2fa4304c73506a8a78"
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