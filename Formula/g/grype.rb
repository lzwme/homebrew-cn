class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.83.0.tar.gz"
  sha256 "c6d650b4442d34cdc4be05130372843d197e5a5b83a112fc58f01cb08c3d4757"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "407f2b3cb5a5fe726384894b41b1cd29efa0971a5711c85c111fa2c7d813b7fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c636a052aa8cffa9b0febe6d55c25e73657d1a70ea0a09b71e6edc1de24ea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ede6cfead560e0d67c47f166c4f557b07dbaa60a5a2d211eaa2eca80a2d2fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7a5da14e282417c5aa4f31e75b49836509898dccd28f2cbeb6e54e034d93c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "918657c64c71fbeb8e13b58d369def82c2cfd036e9cdaa2c3f13d4f9a2b8009d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0790ce9bc44430d73fcee28757a69dbc9cb0cb67cfd546c22b5a0f028974d05c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end