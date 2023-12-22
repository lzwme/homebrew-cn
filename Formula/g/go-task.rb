class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.33.0.tar.gz"
  sha256 "328ab2eb6813dc4ec69d833cb354b38ded6e00a816781fa29465c92c284077c7"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3321e5f00901bfa49c66d0d94ab4d60582bc61437276b023ea13421b5e310021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd1976a08524593e8f8590636401ead30e611d9166baac5c59fa9576fd935b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35bf431996c1843af57d24512d8741e6cde6efa9cba78fcc2f42b5c634e33b34"
    sha256 cellar: :any_skip_relocation, sonoma:         "329353ef5ea3ac92ab66d8b4d4c1f5d9065044031a7c0c2e2fd07303398e20d2"
    sha256 cellar: :any_skip_relocation, ventura:        "3307cdd1fd4cdb76f3380591bdbae793859289f747480bcdf4d1660145caccb1"
    sha256 cellar: :any_skip_relocation, monterey:       "84f3c2cf50a822f4622115f1b49c89e5f3b09420d84755f1f54fe129731e6ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5084f25643dc717bb76c66dcef271195129d50d2a6e872afd28bf8ec6e11e3f0"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgo-tasktaskv3internalversion.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"task"), ".cmdtask"
    bash_completion.install "completionbashtask.bash" => "task"
    zsh_completion.install "completionzsh_task" => "_task"
    fish_completion.install "completionfishtask.fish"
  end

  test do
    str_version = shell_output("#{bin}task --version")
    assert_match "Task version: #{version}", str_version

    taskfile = testpath"Taskfile.yml"
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

    ok_test = shell_output("#{bin}task #{args} test")
    assert_match "Testing Taskfile", ok_test
  end
end