class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "a0171cd32babd1a54b4f0fd392bf07532cb5701434024fe488b634662804408b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c3b7c3d493d64101a881910a72cfe331b10a17b3d691619607c528d4398619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd50140f6113e5d729299a8f7b11e8872d2afeeaa8f6c06759495e64efa00cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab46eaa4a6ff48b64aab34879051e19a1278473753dd64028ea0ae5fd643ab05"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67d9ced55b506ba7b40ef7e8a1426cadda1244c1cd873b657fcb1ff59a5ca61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d7aab587d28b58a95ad5e0b30143796029ad9d3707f80fb805730b424290edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16356337e672bc54e089c917fcec551f8b584c267d351acd9d40f219a5fe397"
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