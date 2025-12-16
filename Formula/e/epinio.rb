class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://ghfast.top/https://github.com/epinio/epinio/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "6ab11c7e3a84e91fd4a2cb1bb0d52cf496b31d1c38d7eaa47a7c527d4dfca65c"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "128b874468bfd7ff2df4143f3bf4ab1b5ba32a06bee2b84514949971d6089e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8915ef3014e2e89c39baac9318444b417bd073ac48f8f7919927300f1baa7f0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d9fc69194f7efbce0dde31117575c7e520b78c0cf025c75824c21409b0f449"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ea26f5aa370a85c5f3e6319d3069d669037b8c895e81067a71b243b0860b3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "249a4be1d67ec2fa389591c7646122e436e29388a9350d94edaac9709cdcc134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30cbe2097d6dfe9e71ca78bee6bdcf79389725865140e32b78e5dac05e7246fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end