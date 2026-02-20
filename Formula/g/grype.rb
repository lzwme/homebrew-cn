class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.109.0.tar.gz"
  sha256 "43e2cfe231d656e2b4d8c144068d40913f67de6c9b459976619fe75a0ec11966"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ed4546c06af987ec7482e40901bd35edbc3b31d401dde46729ff0ac31e8d51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6c14fa1716f146376164969f87213ed896a5ff0bbf502b4810ed431747dd588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9407220800b66294b1e88ed3453d6b030ecab6bfa2cbaea753b04831c9d7f51c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bacf8177d442004ece022d4268f2bf958b5929ff3ddfb830e20d64ecd2c7f95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82ac4ced052867e8b819b283493eb9db6b9be4e61373287d9b1971042b4cb340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a404f3cea5656d352d4d8727a1981e136b8f7b8c25482f0a402af60b743737"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end