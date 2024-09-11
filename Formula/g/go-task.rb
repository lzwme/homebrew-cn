class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.39.0.tar.gz"
  sha256 "f46948b0febe05e316fb71c504856cacc225fd386fee22dc96f025e91fa747f9"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d2cce7dca59074bedead99b3bed0a48edbe3d938f42cae0ce67ef211ad80a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d2cce7dca59074bedead99b3bed0a48edbe3d938f42cae0ce67ef211ad80a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d2cce7dca59074bedead99b3bed0a48edbe3d938f42cae0ce67ef211ad80a19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d2cce7dca59074bedead99b3bed0a48edbe3d938f42cae0ce67ef211ad80a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "34b0c041313d4add2921cd3426c7bd0abbde89a85de65213b996dae7c690cb46"
    sha256 cellar: :any_skip_relocation, ventura:        "34b0c041313d4add2921cd3426c7bd0abbde89a85de65213b996dae7c690cb46"
    sha256 cellar: :any_skip_relocation, monterey:       "34b0c041313d4add2921cd3426c7bd0abbde89a85de65213b996dae7c690cb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416a486b00c5b90372e185a8b7a850b5ff1aad58dfbea4365aa8ec938ba82e4f"
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

    (testpath"Taskfile.yml").write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    output = shell_output("#{bin}task --silent test")
    assert_match "Testing Taskfile", output
  end
end