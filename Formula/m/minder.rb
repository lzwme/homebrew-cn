class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://ghfast.top/https://github.com/mindersec/minder/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4581e8cf6ded68cc1be3c6aa72d4488da00783f6542904cc5e78517773ba6933"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f987ac19189a7ccdc1b4b0f57b9f4028069100c2c407d6a7d1a148211e8fdf9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f987ac19189a7ccdc1b4b0f57b9f4028069100c2c407d6a7d1a148211e8fdf9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f987ac19189a7ccdc1b4b0f57b9f4028069100c2c407d6a7d1a148211e8fdf9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe18f9f0095f47def9ae7e5a624b2f26dd68538eaf700bd6a7c31c6235de2fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce38308b03361ee69012f31cdcf368a72e06805747d979ec7babfa436ab61517"
    sha256 cellar: :any,                 x86_64_linux:  "340dfa96b7c9d19b08c3ba3c86efc51672b744cc8e73788a1b4be979c083a344"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end