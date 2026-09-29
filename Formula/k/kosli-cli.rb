class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "088a017daea833f2dc540485a985177459f0b8f33d3b7c7cd8b295503a30593c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "948c73b79c0adb858db132aabf3f56b1ec477ed8075598b5475e150c35cfd9c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5271591dffefddcc05b84671c38d01d7de9aa5cf224b086c8ee64da66b227933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77cdd9c6cfe0f4e4594bca496f0fb5de0b6fa99682deb7759365462a1f6ec10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3628a500b05551f76562b064f9503de36af5f81ab94b6d9637ae3f6d32e1767f"
    sha256 cellar: :any,                 x86_64_linux:      "e091422e963ef12b6c023e4a3a4799499f1358d47dd3fee3b7367b6e32132c1e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end