class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.36.4.tar.gz"
  sha256 "ee225b27d608ac3fbaaa49ffa83c22c680f0e740af74af63c1100efe02468e88"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "489c439c13da35921202bf0007dee7a267c734129259d928c76695c6ebc28fcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9283471cb77148272426d8974bf40a52f6ebf56d4b5bb991faf47bea71efdb2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f8757f20dd3feb52d70255299c74bc57265564e347ffba51c22dae7635bc08f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b573c1421692746d10099408b4bc12df4875ab7d8979830704fbe6d4833a8964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f39e66e0907ff62fc9245e2eaab49500c750dd08a64150d5df0077c8b6f171e"
    sha256 cellar: :any,                 x86_64_linux:  "40c4b99fcc5e91b0b5af7e1067f98ce4c6bf3d5e6564d9ef2753c663ef3937ac"
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