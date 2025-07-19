class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.18.14.tar.gz"
  sha256 "accad98c3cd174a38e7567e4657c2748bcd6881cd397e228466036b7a4e6d83c"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8f9f8fb3d91c5fda8c069928f40c33a4804a775bcbef323e00aa752f227c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8f9f8fb3d91c5fda8c069928f40c33a4804a775bcbef323e00aa752f227c6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8f9f8fb3d91c5fda8c069928f40c33a4804a775bcbef323e00aa752f227c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7cb717af9c29b0944b6e21481b2b70fc4c5adad769fef6f579c16ffde3d6aa"
    sha256 cellar: :any_skip_relocation, ventura:       "6a0c66f240c57e9a620e8f0a2ecc8f60f07e3b6f2fbefbc6ea2fa41f1e734790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ec08be5df8571360758ff3e3a3ec9bfab3fd42c0c66995c697230aa2b3d309"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end