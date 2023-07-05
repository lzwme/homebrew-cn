class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.6.3",
      revision: "104ff1fc59c4e2cff377a9c970f76553261cd579"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086054e6e619ef1a7839e60f982d37cc50174f35ccbee9e32943bb320f883c09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc04980845534712e8a6a4c2c5159847975e74b03390722c5e595b4ffde5bab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98266be32d2c119f417316d3385c9ae99ad3f5b59234581691764732a3b3be9b"
    sha256 cellar: :any_skip_relocation, ventura:        "77353da665a27ed3dc0dd479b836db2c73512516d9b1f152d8fb906167afa57c"
    sha256 cellar: :any_skip_relocation, monterey:       "2a4ecfb85bf4673fc942dc0743ab2025e0fae2138e4b1ddf49f0d9476cf584aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "d65472f5e714254ebc75f4361d0d32a3bf2e7f0b02bb261e792abd201bdc5095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bae7f22aede78369c001707138f8da5be37f2a99a98aafa249d6c8d53e99468b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/internal/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end