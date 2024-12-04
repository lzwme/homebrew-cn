class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https:github.comknativeclient"
  url "https:github.comknativeclient.git",
      tag:      "knative-v1.16.1",
      revision: "3bf1ed8eb51e4700d253b654866063bf5421c863"
  license "Apache-2.0"
  head "https:github.comknativeclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c99832693fadb796b65f38321be89cc3ff9670f7664e9a616e298e946bde54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c99832693fadb796b65f38321be89cc3ff9670f7664e9a616e298e946bde54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05c99832693fadb796b65f38321be89cc3ff9670f7664e9a616e298e946bde54"
    sha256 cellar: :any_skip_relocation, sonoma:        "137e3dc95c343860fa811c8c4ab3c89f3336293f8cf70d5d4015175777e4fd03"
    sha256 cellar: :any_skip_relocation, ventura:       "137e3dc95c343860fa811c8c4ab3c89f3336293f8cf70d5d4015175777e4fd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5c5476ed3bded8ea9b02f67be6c2c290ebdde1ecc71ec9ec8a6987727880c0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.devclientpkgcommandsversion.Version=v#{version}
      -X knative.devclientpkgcommandsversion.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.devclientpkgcommandsversion.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmd..."

    generate_completions_from_executable(bin"kn", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin"kn", "service", "create", "foo",
      "--namespace", "bar",
      "--image", "gcr.iocloudrunhello",
      "--target", "."

    yaml = File.read(testpath"barksvcfoo.yaml")
    assert_match("name: foo", yaml)
    assert_match("namespace: bar", yaml)
    assert_match("image: gcr.iocloudrunhello", yaml)

    version_output = shell_output("#{bin}kn version")
    assert_match("Version:      v#{version}", version_output)
    assert_match("Build Date:   ", version_output)
    assert_match(Git Revision: [a-f0-9]{8}, version_output)
  end
end