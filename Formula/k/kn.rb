class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.6",
      revision: "4a791c5d2bde3549f36cbf4784d2e6a43e498d77"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2804ec41305b97f7940320094cc99e9538cde42c86aa6de055ea82d0ebfd1553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8cbe81c25596581370637b3606b937f86bdcdc528dbc279685dc0a1bb0f4aaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "510a266b12179b02cf8e9be8ae80b847447772147ce9b13ccf9ed1afe93d123b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c51353686d67793f771426ced2a8b9e3a5f26dbd1094212beb702aa3f8497731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bbd86e07d3007674fc493fd438ff55161408a2016388b3c8896ea465419aef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c84cda195dece9cce362cf14d9d5ec47eab7d69d421f70081ea3ea327661530"
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