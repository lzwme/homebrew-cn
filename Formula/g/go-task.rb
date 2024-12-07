class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.40.1.tar.gz"
  sha256 "e80cdfa2afefa69238e5078960d50a8e703de1043740b277946629ca5f3bde85"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11446cbb6f0acb73b7eecac3d19ee4a5fab3cb13f5d2fee8a0f311fa0f0562f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11446cbb6f0acb73b7eecac3d19ee4a5fab3cb13f5d2fee8a0f311fa0f0562f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11446cbb6f0acb73b7eecac3d19ee4a5fab3cb13f5d2fee8a0f311fa0f0562f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "461c2d50e15df0367f5e21d723b3b98fa83ef2b9d7d64d46928a0a8893a5db99"
    sha256 cellar: :any_skip_relocation, ventura:       "461c2d50e15df0367f5e21d723b3b98fa83ef2b9d7d64d46928a0a8893a5db99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc62a119ea159200602c26fbd9c6ea8281d47dd2e1e9e038de840e92ad8c951d"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgo-tasktaskv3internalversion.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"task"), ".cmdtask"
    bash_completion.install "completionbashtask.bash" => "task"
    zsh_completion.install "completionzsh_task" => "_task"
    fish_completion.install "completionfishtask.fish"
  end

  test do
    output = shell_output("#{bin}task --version")
    assert_match "Task version: #{version}", output

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