class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.40.0.tar.gz"
  sha256 "e5ef4dc1837ca35f05cb5065aca3ea3de30e363c2ded389b6b1c0896cf1770f3"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6628de60c413326a3ba8ae8312341aa4353ebf95c198aa91800e7ad09fed954c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6628de60c413326a3ba8ae8312341aa4353ebf95c198aa91800e7ad09fed954c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6628de60c413326a3ba8ae8312341aa4353ebf95c198aa91800e7ad09fed954c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a686eb3d3bfc48a31a2683fd69cb25b056fdb4e23502cb1ba68e259a313abdb3"
    sha256 cellar: :any_skip_relocation, ventura:       "a686eb3d3bfc48a31a2683fd69cb25b056fdb4e23502cb1ba68e259a313abdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2505c38729002fda83c1290e15973f56e65a4b47be23b042a559ea7af3c62111"
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