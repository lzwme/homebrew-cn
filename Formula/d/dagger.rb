class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "2fa191179ec92b5116b3774d124c3bbe2bc24f15d597faf55e2db5ba921bfa29"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e416d17f0376f6dc66aaa28d7e9cb951d8a49ef8d7a59141fb8b803f2cc672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e416d17f0376f6dc66aaa28d7e9cb951d8a49ef8d7a59141fb8b803f2cc672"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e416d17f0376f6dc66aaa28d7e9cb951d8a49ef8d7a59141fb8b803f2cc672"
    sha256 cellar: :any_skip_relocation, sonoma:        "3781dd809d270ae8309e099629f00dde4a0cd373b05475f76383ed3241716768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57f306ba1b65869342aa69074a9adbbf80622fb1e713025f9edb36968a71696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e9015937b1f3f4d4083557366a81bcf4cbf3197647ee67d4bce6a077d10a54"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end