class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.39.2.tar.gz"
  sha256 "ab61fcbda930ef3f69ba721b3d0dcf531ad0928bbabb17650de607580382f405"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98bc5533f4346774d1d0be8d4dbef3b49dcb0cd23c800c755fbf81ec54140823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98bc5533f4346774d1d0be8d4dbef3b49dcb0cd23c800c755fbf81ec54140823"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98bc5533f4346774d1d0be8d4dbef3b49dcb0cd23c800c755fbf81ec54140823"
    sha256 cellar: :any_skip_relocation, sonoma:        "88dfd524666a722fdcd71a907ed8438dff972ec892121e5f135b047f8aea4109"
    sha256 cellar: :any_skip_relocation, ventura:       "88dfd524666a722fdcd71a907ed8438dff972ec892121e5f135b047f8aea4109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4393051d36a8839dd3c35de507283db01d5dd3b44574a08026acf3c95ffceb"
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