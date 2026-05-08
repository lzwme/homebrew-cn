class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.6.tar.gz"
  sha256 "f116224febbf0e9d2b29e6d3282c8cd3c7398de77711837886493402fe6b2f7d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386382e2c0aad2b2b517eeb96d3474341b235476078f45469c9b2d2d9fa2dd9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d13c28e2e9920eabad63cc38523a504da329edae17761af3bf921e6fde3f8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f74ec30342fe28d52fb7e1a544a785d3c38aa4e0f7052302d9fab318aeaad2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f7ec2f55238e90bbc230284fca824a401557c6024d4343d4b25fa070c9d30e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147a4990713c1341858b9c33812c32cdef7798119c29d80abd7b7be057027386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5ee909ef073ee2f92a5018144e7fc7c0e217a70dc9541e74b889a44753c1bd"
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