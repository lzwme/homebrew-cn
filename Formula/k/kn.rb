class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.1",
      revision: "dc1ccfad8ee1dfa7a2535b2b9dfbfd0064677558"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31fd9464a3ad4ae864a813fb4eea75cb40b2047b6233bd5069ef175cbdcf1788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67638d5153ac55448e0dabf072e92aae11237a9b6b71f828ef0469395f4a654a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38c35b5b6c19b6a4cf4306779108521b7e65c90436f196d26ad3d11cdf3abc1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b05b5c89f3a38c991fe8783ae23430d06c317e1b657f305b9d291602779b425"
    sha256 cellar: :any_skip_relocation, ventura:       "5d8651687b37cab4b1ca3ac04b1b9e2d04c0c64a3bf45182565183af3dd47a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767fbb4311a0478eba0ce15fbca46b0fb1559d56fe56ef26381fd1483fb6b5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3de63a30c79838da937209ec277a40f4a70f0b2264ee0385628669dbce7184"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X knative.dev/client/pkg/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kn"

    generate_completions_from_executable(bin/"kn", "completion")
  end

  test do
    system bin/"kn", "service", "create", "foo",
      "--namespace", "bar",
      "--image", "gcr.io/cloudrun/hello",
      "--target", "."

    yaml = File.read(testpath/"bar/ksvc/foo.yaml")
    assert_match("name: foo", yaml)
    assert_match("namespace: bar", yaml)
    assert_match("image: gcr.io/cloudrun/hello", yaml)

    version_output = shell_output("#{bin}/kn version")
    assert_match("Version:      v#{version}", version_output)
    assert_match("Build Date:   ", version_output)
    assert_match(/Git Revision: [a-f0-9]{8}/, version_output)
  end
end