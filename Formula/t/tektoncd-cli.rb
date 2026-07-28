class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://ghfast.top/https://github.com/tektoncd/cli/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "ad234826a0663fbcd8840bfd7ce4aded21b20eab31d054b666d748f948938957"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a959bc31d3201343576dbe0122e948bfd55920194d2daf7ddf1dc3545c07974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8571312ecaf37437ef5284b7c4b1a221731f76356b501a429e5e88d9f6d0b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b95e0ade800e641a64f2c976939a5951d83de5e5d12d1d6163fc7f84d742df97"
    sha256 cellar: :any_skip_relocation, sonoma:        "284b85d5cec74f56d20f220e9b35498ec9c1f5bcab128c71d73d79ad7e5e416b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "844417d27c2f9960c66c108d5f1fc7c81bd4fc1356627f9cf23d661a99c86135"
    sha256 cellar: :any,                 x86_64_linux:  "4e166e095f5338c9acf905e83ffc6ad84236272373eb9a3a42e75770fa4dd964"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end