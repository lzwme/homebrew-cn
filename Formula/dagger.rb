class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.6.0",
      revision: "f525a276ff9ded404a630ba66c6b3eefa4b6c87d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e46bc847a4991c2f976aa6757aaec2af3cc334e20ef83649f5b332e04dffc3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d727cde2e7cb4b731a7bc5fb528d18394fb4fcfc2814b4de86e694fe9cc17cb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a626b6a88a83099f77ef47ce14d9b8b28abcef42f033d7fd289eafd43f6664fd"
    sha256 cellar: :any_skip_relocation, ventura:        "7a3dce2e629d015085532f9cd376cc7504a020dafd8563b62aa175d1237d2f43"
    sha256 cellar: :any_skip_relocation, monterey:       "892ab80fb2bc029ac054f29eaee45fd63b20a4819553c5c518d4934619b2cfc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee8f05d929a704fedc2ef916468359e76a5e691c5e824dbc7f28726b3e3874bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef06859f4ce31c43e5c6c02b95f4686a67648622a1a60829b795adcab41f846e"
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