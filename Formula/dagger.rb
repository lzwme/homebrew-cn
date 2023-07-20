class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.6.4",
      revision: "0889c0961c764fc9fbd7cdecb67e5ba388a6ca01"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "370a67e42981895069311996a7b80b07d04a4fe87aa4ebad680845e006c3500c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "370a67e42981895069311996a7b80b07d04a4fe87aa4ebad680845e006c3500c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "370a67e42981895069311996a7b80b07d04a4fe87aa4ebad680845e006c3500c"
    sha256 cellar: :any_skip_relocation, ventura:        "6e2ec015e1891bcc157395ae08b8aafe922ca806d9e6363e7380cc32626f96a1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e2ec015e1891bcc157395ae08b8aafe922ca806d9e6363e7380cc32626f96a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e2ec015e1891bcc157395ae08b8aafe922ca806d9e6363e7380cc32626f96a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3fd965e1300535be4f8c9c616d8d6a4e441002ba92e9471372198a8fe28607"
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