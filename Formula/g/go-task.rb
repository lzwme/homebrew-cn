class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.37.0.tar.gz"
  sha256 "a7c97340dc0aa1f793f4cd6f5687139032189d08ffddbc17287007e6f89bcf7c"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "225665eaabe259740b4f1fa82e4ac9e99c9f8955d714175a7c4398007d10c1d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04e28f212fd5322c80aa7bf00d158d543f1489d0b90ee7831459f22412fe36b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f8bdb4d13d2ed78c3fc4f03b46c8b12c5cc9f28409495dddf29b00b3367817a"
    sha256 cellar: :any_skip_relocation, sonoma:         "38a73182cdba96643e6bdff6722b481a3e0da6a45c3309f9c59799f018a8e803"
    sha256 cellar: :any_skip_relocation, ventura:        "4664b4e45737dc41d4b6cf65a730c00e1ad76c1df1f63f648563ccd301a8b5fa"
    sha256 cellar: :any_skip_relocation, monterey:       "62f25a765d29daa0b6f0ed034426bbbb3848d42eaf01070f291f8ac10ce6058e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2222a3c878136b385f0a8a0c4c4920737da093bc63cb3f4684bba76f33a04edd"
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