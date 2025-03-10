class JenkinsCli < Formula
  desc "CLI for jenkins"
  homepage "https:github.comjenkins-zhjenkins-cli"
  url "https:github.comjenkins-zhjenkins-cliarchiverefstagsv0.0.47.tar.gz"
  sha256 "4e78600e214c357c08a0a83fe9cc59214b0d050de07dbb469d9f226c8c37eabc"
  license "MIT"
  head "https:github.comjenkins-zhjenkins-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85ed47aaf4a16751608eef650d8b7cab3e8af8c8133ed82bf6a7305004adb110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85ed47aaf4a16751608eef650d8b7cab3e8af8c8133ed82bf6a7305004adb110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85ed47aaf4a16751608eef650d8b7cab3e8af8c8133ed82bf6a7305004adb110"
    sha256 cellar: :any_skip_relocation, sonoma:        "61397dd36ee2b9195bbef96430a8aed787a0a38e733ed397c425400e03304848"
    sha256 cellar: :any_skip_relocation, ventura:       "61397dd36ee2b9195bbef96430a8aed787a0a38e733ed397c425400e03304848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b253ad3ba372e8bf59b0724c656e5ce77b8b522cd9651e731aaea6d846309e78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlinuxsurencobra-extensionversion.version=#{version}
      -X github.comlinuxsurencobra-extensionversion.commit=#{tap.user}
      -X github.comlinuxsurencobra-extensionversion.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"jcli")

    generate_completions_from_executable(bin"jcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jcli version")

    (testpath".jenkins-cli.yaml").write <<~EOS
      current: default
      configurations:
        default:
          url: http:localhost:8080
          username: admin
          token: admin
    EOS

    assert_equal "Name URL Description", shell_output("#{bin}jcli config list").chomp
    assert_match "Cannot found Jenkins", shell_output("#{bin}jcli plugin list 2>&1", 1)
  end
end