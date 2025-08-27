class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.2",
      revision: "091f88684b9cb1d02e2ce8594e71ae7e8f452c7c"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4adb941e4f3bbd017b59f1402e5b0b543b9d1cff7a291df81c882c14e6d76c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b6dd5d6c5ce8404bd08ed4a7d61c5eef409f8a4f160a9f057acc88e32542c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be3d322a7ae1d2c1b36d10fa3e17382ca33eabf9031e755c05761957850fc4cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "162703a4bff36876f13570eef64a93074805dc183673e6f2101918d4a700e736"
    sha256 cellar: :any_skip_relocation, ventura:       "8663d7cf36160b385718998be296d7823df3194ca32968514938fa3134629619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06df782891ff20d765262b8b1cf640716e1b25c4780cdb2b17b9fcae11ce21d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f60f01a4b6beefddd20c6bed970cc7d4d0f28f4013f4c99e02a2f8050bc00c"
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