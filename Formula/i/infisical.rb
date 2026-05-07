class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.80.tar.gz"
  sha256 "a18fdbaff77564e433611d0c0f699999c085b33bef4f540e10a09de57dd99e48"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63fc3d11ca5d01c4f16cb4c3aaea63a86406d4826db27360fb781d7fb56c9f42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63fc3d11ca5d01c4f16cb4c3aaea63a86406d4826db27360fb781d7fb56c9f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63fc3d11ca5d01c4f16cb4c3aaea63a86406d4826db27360fb781d7fb56c9f42"
    sha256 cellar: :any_skip_relocation, sonoma:        "a763e3ca931ee85556a91035f77ab4646214d885cc9b0a98e920e40dd6f0bf6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e36ff34ad502bf1f1c701b4c72d4f6283945a9b8a0fba46d4bb54ecc2c319c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acbd3ba8e3b3142b7385bb106542e3df5d62b0aa4a6e03b7f6ec78bf0a47f4be"
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