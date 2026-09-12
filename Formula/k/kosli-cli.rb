class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "af484e41da4fe3750aef121eb5350d9f585fd4b1a31209f47ba833ffca999b75"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11300023b8e529ddd55055240d0f789538856014ab9a3e2a9be7239faf080309"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27439dc0cd3a75e6f2f558113b9395aeee971531ae42b465a89055de7ed87679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4519e3a524af9a3fd3b9f430b544980d47137bc7e495c7599ddd98d39339cc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd3307481b6268476c21b1c450a9c774b9858f7f815f78ee579f1259c42b251d"
    sha256 cellar: :any,                 x86_64_linux:      "c25efd8a126781dcf10222a8a914f793cb74264ad0b1943f5080e4d52c2859e5"
  end

  depends_on "go" => :build

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