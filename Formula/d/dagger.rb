class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.18.15.tar.gz"
  sha256 "a1048f413c5eaf12df870bf6f16f06d4d71dd9afac91e5cb3a67491d24424f18"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c138b779e5b13770d8fda57cd7460be364a7416f33b0099838b2b82256a5afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c138b779e5b13770d8fda57cd7460be364a7416f33b0099838b2b82256a5afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c138b779e5b13770d8fda57cd7460be364a7416f33b0099838b2b82256a5afc"
    sha256 cellar: :any_skip_relocation, sonoma:        "134234c0e58be72344fb18985b6597f201fd519de3a38be399ebc37f01ac6d09"
    sha256 cellar: :any_skip_relocation, ventura:       "58fa3d1c4c43f5a44db4271a8bbee7ce69068fce17b6f6a68ff6a2981d15e760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b808703ce578340a97c5fefec7c699bd94cd417fb3d584c8ff363fb5062c4fd"
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