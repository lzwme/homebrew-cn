class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "652fffab225340df36ea4f65eded61628a9cf5f1dd2ac2f667aadaa5d84eb430"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c006567c0c30ac15fa2ae409dc9038e775193e180d1ae9ce2c5c72b2f7376723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c006567c0c30ac15fa2ae409dc9038e775193e180d1ae9ce2c5c72b2f7376723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c006567c0c30ac15fa2ae409dc9038e775193e180d1ae9ce2c5c72b2f7376723"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af26bb659202fc0f636a248128080ae58d507f5eb82bc47e7146494cb2dc8ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "152fde54f74bfba2f50cf583263e309839d8fd73d6074a2a2a73dfbd7bc3f6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010f907d51bbaa26e7d1ac8f1e10bb117532cb7f58c4406952f79ca795b23a47"
  end

  # TODO: switch back to `go` when x/net is bumped past v0.54.0 (broken with Go 1.27)
  depends_on "go@1.26" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end