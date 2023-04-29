class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.5.1",
      revision: "00540aab79993e33bb76933edbb174db1d06a87e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f688dc50ac05898e5acfd438aea410fef80a2cd4217695ac5676c68ae4132e7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7189df716d7d069584c71d2a4ae7bd3305f2b03bf1498f69c8d0f6577558b3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5dd06c0920580b37767861574ef5d6430e1e79e77d8add3ed82d24d2b0f4471"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe4a6268ea81b7b916466227853cb241eec6b98ca6a800b23fcc81f8610e574"
    sha256 cellar: :any_skip_relocation, monterey:       "eb8b7d377bd072169f8a723f56322867f202ac89c5f91a18e02ff5379aee65e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d74fa2ccd79631c8026b9eb6382db1c974205a7c124d7034ef7fa4d58ab59b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235faae30233d8db3f17bcc3be6e59a3b29c8dbf3cc241e810032401056b0bd2"
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