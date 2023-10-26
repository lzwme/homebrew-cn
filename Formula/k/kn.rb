class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.12.0",
      revision: "ae35736892402050eb910d2b43a70f41e1d225c4"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cf84af1c41b456369abcff2b9ff096b35aaa2253934a37a3fe04695ba256ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70cf84af1c41b456369abcff2b9ff096b35aaa2253934a37a3fe04695ba256ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70cf84af1c41b456369abcff2b9ff096b35aaa2253934a37a3fe04695ba256ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9701f158cdc1d701dbbc7e2238190f21fbd6a30d946e3673a14407eb14e8ed75"
    sha256 cellar: :any_skip_relocation, ventura:        "9701f158cdc1d701dbbc7e2238190f21fbd6a30d946e3673a14407eb14e8ed75"
    sha256 cellar: :any_skip_relocation, monterey:       "9701f158cdc1d701dbbc7e2238190f21fbd6a30d946e3673a14407eb14e8ed75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bbfecae1b0b7564ae9a0425decd66151c90b40cdcf0685acfd37aac4ef9a57b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.dev/client/pkg/kn/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/kn/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/kn/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags), "./cmd/..."

    generate_completions_from_executable(bin/"kn", "completion", shells: [:bash, :zsh])
  end

  test do
    system "#{bin}/kn", "service", "create", "foo",
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