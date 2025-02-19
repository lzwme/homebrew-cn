class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.7.tar.gz"
  sha256 "a3dba4deae5313bf69b9ca43672f833ed0dddc344fdcc8227b3ea7bc8242d465"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2d0000a8be22b809162163742caa24f6c198798cd69647fd6d61a3eab5f002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ef8ecfbd5c188a92137e09af7917237bb2fd0e6a66666c87891a908fed01d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1483c728f4013d2db343e914d9a00363460328e29e9fa28ca47db6b17fda9397"
    sha256 cellar: :any_skip_relocation, sonoma:        "d31812f0223dbaf1a0d71c503bfd555be6d98bd458800da76ed23e4f8f90b77d"
    sha256 cellar: :any_skip_relocation, ventura:       "42450b8b986744b89b350d26d09489692982f1c17904092fb58244ddae1e5ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6ba861e5afffdfad1f3e09534aba4dfaf89833f27696bacd4445db20662aee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end