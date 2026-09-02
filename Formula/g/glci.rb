class Glci < Formula
  desc "Run GitLab CI/CD pipelines locally"
  homepage "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci"
  url "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci/-/archive/v0.7.0/glci-v0.7.0.tar.gz"
  sha256 "350367daf09af8da22b0d4376222bc004c43b372151d6206b3ce717857c15d62"
  license "MIT"
  head "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1f5670f585498e4a420a2fc85c973d59ce8ba036954f630447287a00d8a115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1f5670f585498e4a420a2fc85c973d59ce8ba036954f630447287a00d8a115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1f5670f585498e4a420a2fc85c973d59ce8ba036954f630447287a00d8a115"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f695ba8e6e82746d09316131b6f62a27670afbe7701b5ac94ee7e4fc13dd4542"
    sha256 cellar: :any,                 x86_64_linux:  "3fef0c83ec9697ab4f1b25545b4cfd345ecb00c47a007dfd37b92c6f68a41346"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = %W[
      -X gitlab.com/gitlab-org/ci-cd/runner-tools/glci/pkg/version.Commit=#{tap&.user || "homebrew"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/glci"
    generate_completions_from_executable(bin/"glci", "completion")
  end

  def caveats
    <<~EOS
      glci requires a running container engine (Docker or Podman) to execute jobs.
    EOS
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YAML
      test-job:
        stage: test
        script:
          - echo hello
    YAML
    assert_match "test-job", shell_output("#{bin}/glci jobs")
    assert_match "test-job", shell_output("#{bin}/glci show --plain")
    assert_match tap&.user || "homebrew", shell_output("#{bin}/glci version 2>&1")
  end
end