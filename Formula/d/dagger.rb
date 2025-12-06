class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "ff83e6697a783720c16bbc1912fd6dad00df7de30ae81bf688b7fc51520ec76e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "679e164ecb527c23ff379bbee3bf712d1fad61ea33b2c2538b8cd8ed2a81828b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679e164ecb527c23ff379bbee3bf712d1fad61ea33b2c2538b8cd8ed2a81828b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679e164ecb527c23ff379bbee3bf712d1fad61ea33b2c2538b8cd8ed2a81828b"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb946d8e4c530dab34b49da8c599be52be09ed622f76cbe6625b369fbfe6491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993bfbb2d71b1af013badeabe11eaefdb43f4f569bc795853b600b335cb809bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b898f17d7645140a082d2551892e57f6464e09eee61cfc2847b4ead9a1fc6bd6"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    assert_match "failed to connect to the docker API", output
  end
end