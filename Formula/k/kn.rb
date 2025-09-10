class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.4",
      revision: "62fdfbf240e0277a0e0df99e45badd5af86abdf8"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea49a46be941b460daa99712ede09963b2263c88a6c22be5e5d66ad48f7410a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4d4708c147b35dcc775ce1f44e8e1034d69f2278252785df3953af2ece6a3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0541521eb2eb48cbf8514f659f75dda24d30a2ac4b935614269c7a3b0aa7e0e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f72b9045b735cab4b1227c659157ceae5af7a52cfb546d63a10f5e909ae816c"
    sha256 cellar: :any_skip_relocation, ventura:       "bde5f1ac8105aebde546ae3ced7ba6c3291397850d2883971b68258f0b81af70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71709ce3e666b656d299a57ccecbe1358abf77ac2a0d465a6de5492bd763dd0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8389076a8b3e05f41df6b2e126a8e36756f4afdadb09265990f478d569f8c639"
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