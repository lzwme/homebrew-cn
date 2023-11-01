class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.2",
      revision: "a7b02a33007a886ec93ebaa5ac7a4500911febab"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d30f629593ac8fd297402abc0fd54756cf3401a98e0368e70fa31ea9fdb53565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c00a7457476ebf759405b0aa9232d0d544340ec1b7431ffd8ae946d0a8994df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb32f8dc897c6aedc6c64bc761e202949d3c2c6377f112b5915d8fbc8650d697"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb6ba24b2b73d761422f25b80eca33e3afe0ce8c87fe9a1671c31badba0bf7c6"
    sha256 cellar: :any_skip_relocation, ventura:        "e7fd3e3ff43dc73e955bbd6b74350ea8dd90c5d55d9cfd798c7a65e9452e8135"
    sha256 cellar: :any_skip_relocation, monterey:       "831da065206e4203fe5067f3ac71391bdab47af055e44127d3b40e4b4ed7cc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e22ba933b45ce2e921bccdc20a0b37c21fce1e82989fe7e84c17bfe7c7d04c"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
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