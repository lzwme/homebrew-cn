class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.0",
      revision: "fcc5f74af535829de277bdf5909bd70606237d49"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac343e8b8543f8b57733929388ff757c7c34bb1c7625984cdb965e0adceaed3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403546dad8da0534291140b7b9da2d3b70410af6ab15ab4d4e13d1afcf19fb79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "261b662f0c29068b9d832e9ea82052f9c408a90e02e9edaea9610a774a058552"
    sha256 cellar: :any_skip_relocation, sonoma:        "383bf0cabac25e58d67ac589b456ba96a0ca3e856a90a172b23e052dbe5f77d6"
    sha256 cellar: :any_skip_relocation, ventura:       "0fb488c8c18a68cc16d41ff106f5a5bb41707dce1376c3ab0ae3770215810d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f36a6da7acb7e86eb12c7ea2b405892e28e18553afb13256ac4ea925422985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a280d666fc1524016e0921ea24488b4e1974c1097056179e74817ab1bbe9a96"
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