class GoTask < Formula
  desc "Task is a task runnerbuild tool that aims to be simpler and easier to use"
  homepage "https:taskfile.dev"
  url "https:github.comgo-tasktaskarchiverefstagsv3.42.0.tar.gz"
  sha256 "8d3cd23ce03a40fd40d37ffb5c36ec2b4be5f4e01ca110e719297d1c75c42d65"
  license "MIT"
  head "https:github.comgo-tasktask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c221635f31e48bff6c52385851d9f3a78dff8c1f469e2bd97bb56f82554a705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c221635f31e48bff6c52385851d9f3a78dff8c1f469e2bd97bb56f82554a705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c221635f31e48bff6c52385851d9f3a78dff8c1f469e2bd97bb56f82554a705"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc3d29b476e3c3c4fc8c7143adcbd285b61183a30a58b6439fba07e1aacbdd7d"
    sha256 cellar: :any_skip_relocation, ventura:       "dc3d29b476e3c3c4fc8c7143adcbd285b61183a30a58b6439fba07e1aacbdd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b28e852669bc502e1f23cf3ac7b2e18b80ae25b1c25609c16a4f08dc9fc7f90"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  # version report patch, upstream pr ref, https:github.comgo-tasktaskpull2105
  patch do
    url "https:github.comgo-tasktaskcommit44cb98cb0620ea98c43d0f11ce92f5692ad57212.patch?full_index=1"
    sha256 "78861415be4e9da4f40ecff7b50300926f70fc4d993c3d83cd808040d711b35e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comgo-tasktaskv3internalversion.version=#{version}
      -X github.comgo-tasktaskv3internalversion.sum=#{tap.user}
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