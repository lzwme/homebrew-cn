class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https:github.comoras-projectoras"
  url "https:github.comoras-projectorasarchiverefstagsv1.2.1.tar.gz"
  sha256 "200e843a5aa0f375b23403cd5442d77243600d92dc62a1acc8dbc2a2e6b72dd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3fe2d313f3e4f40427aea6618221df0ecc2556d1cb4c48916392bf96e8847a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee3fe2d313f3e4f40427aea6618221df0ecc2556d1cb4c48916392bf96e8847a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee3fe2d313f3e4f40427aea6618221df0ecc2556d1cb4c48916392bf96e8847a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2485dd828561b70638b85054550440ebbd2beee2d47abf87a680200a29d87f6a"
    sha256 cellar: :any_skip_relocation, ventura:       "2485dd828561b70638b85054550440ebbd2beee2d47abf87a680200a29d87f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e339188f3f28aedce92a07d29e97989a933dc4c40ac58497ba860dbb25c635"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.landorasinternalversion.Version=#{version}
      -X oras.landorasinternalversion.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdoras"

    generate_completions_from_executable(bin"oras", "completion")
  end

  test do
    assert_match "#{version}+Homebrew", shell_output("#{bin}oras version")

    port = free_port
    contents = <<~JSON
      {
        "key": "value",
        "this is": "a test"
      }
    JSON
    (testpath"test.json").write(contents)

    # Although it might not make much sense passing the JSON as both manifest and payload,
    # it helps make the test consistent as the error can randomly switch between either hash
    output = shell_output("#{bin}oras push localhost:#{port}test-artifact:v1 " \
                          "--config test.json:applicationvnd.homebrew.test.config.v1+json " \
                          ".test.json 2>&1", 1)
    assert_match "#{port}: connect: connection refused", output
  end
end