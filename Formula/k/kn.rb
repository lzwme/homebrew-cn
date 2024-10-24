class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https:github.comknativeclient"
  url "https:github.comknativeclient.git",
      tag:      "knative-v1.16.0",
      revision: "b3b6b8603082732a6ca69b70ebf5d9d4ed48d804"
  license "Apache-2.0"
  head "https:github.comknativeclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcebd0e10b9d2ef2ded66dfe973305d72f35c7f1bc72cf5bf4a609f79fc52ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcebd0e10b9d2ef2ded66dfe973305d72f35c7f1bc72cf5bf4a609f79fc52ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcebd0e10b9d2ef2ded66dfe973305d72f35c7f1bc72cf5bf4a609f79fc52ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "06725a6ea4379f310651ac82c5c971f80826d2f23e29724e12d70a92b840a338"
    sha256 cellar: :any_skip_relocation, ventura:       "06725a6ea4379f310651ac82c5c971f80826d2f23e29724e12d70a92b840a338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "173449fa365517d5867704d0db1f62722cbb1ab588e41fb19d5f010255413b85"
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