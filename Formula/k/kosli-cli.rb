class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "cf81cc804a5664092c78782c55d02695690d5945451612fcb94f1864dd655812"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5adae6b4c154dfccd588c8bb0edfa61035830c6cf6d969624460e9d1f21e36f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b2c2723dfdac7809bc8d3baa0b932983e74f48f390a86a22730727732b3c68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34656605b84a8af4bb10f73b1aee2184b1e30dcef04bc7e657f6c8f4599d848e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca4dd8765e2a53172ffa7f7c8e9d6fbe55b1d1a79bddf95d5e12807c340b2dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150376d2b140c0ccc93b266685f066797d401e7f208c77a9c18a5117d5472e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce59dc43e0a78f0977a379f25bd689ac082d27328d0c67006bcd105f7a49b17e"
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