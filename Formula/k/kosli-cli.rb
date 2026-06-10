class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "3eb96a560ecb4e100abf35ba2683fd9324c8b4b6587e0b4d7955cb3486c22cf5"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb34fb49cee8b2f5afe0daf59891cb19770697c8475150f89255784dd2f40df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7041f042a0359611c45b38bdc26eed46320571437558d24fd1ac94de764d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3130b090861eca1859e2b6eea33521384f70349851d014865e064c464a87fe44"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e6e123650a22242e598765fd4b10e9f7c0fea3f3d2f937c4295842d7530079b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebbcc364dadbdc85ced5cce74bad0bcabfbadc832cfdac197149dbfe33e22d3d"
    sha256 cellar: :any,                 x86_64_linux:  "502d8fc0bf38a247bb4b298301223f9cfc820bd50019aaa2e9e889328cb5475b"
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