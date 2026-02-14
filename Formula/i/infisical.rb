class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.55.tar.gz"
  sha256 "77bbdb25c4805774a036a80c4b74da7db0a663a51a3d1dcf0060733bf1259ace"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03499dc09199f419bfcfead5c48f52a5ba48142653ec061b54721b4cd52b1db1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03499dc09199f419bfcfead5c48f52a5ba48142653ec061b54721b4cd52b1db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03499dc09199f419bfcfead5c48f52a5ba48142653ec061b54721b4cd52b1db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2c712431b43242f4377c0d8a33d63a8a65195289486952a862cba96a89ae7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c5c087b5ad8983155b4c9f09de68c0662553d8def16686afb22922ebeba120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a1e9d347d33367a64d32c16750b6ed04346463f394605c088831120889a361b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end