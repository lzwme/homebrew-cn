class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "290a015b637215343d032d42aad1c6e3d23fa3b53bff2a17a98cbfd4690a3614"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "559118d260ec9cf0c9e7fca15f171aa5bfa7804dc4b06f276281917eb8831519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94146ef4a3d1c50490bba2ddf41781a11e7aba43bb56417f94afe29d43269f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "229ee7f82c260a515cbbf13c799eca4b685b9766c450d71e2dab0a049e774146"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e0e6bee5f910cdde065c10e65e9033d3fa2ee6a521b4f6adf03c2318b5526d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c089438f8c47cf23304b1b33d26014e6478f2b1e1d7a7ced1c92f8ee8a8d8f"
    sha256 cellar: :any,                 x86_64_linux:  "457f2b540a3ea2ced7a551417c74dcbd508807d05dab76f50cbd99f5ee83e995"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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