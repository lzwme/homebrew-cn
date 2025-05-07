class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.6.tar.gz"
  sha256 "8267c50c7721d4ff8a1767f2d5c25c147001602296ab34aa96ea68974bcd2b17"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7124a6988af0aedf13a39d8aaf6d8fa10a5a644ff2ee14d18f20afddadd78b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7124a6988af0aedf13a39d8aaf6d8fa10a5a644ff2ee14d18f20afddadd78b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7124a6988af0aedf13a39d8aaf6d8fa10a5a644ff2ee14d18f20afddadd78b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d667ff10d2372c4457e04a351c89bff4e2f5a8ac6fa97d59ec3992b1be6a650d"
    sha256 cellar: :any_skip_relocation, ventura:       "d667ff10d2372c4457e04a351c89bff4e2f5a8ac6fa97d59ec3992b1be6a650d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef399c6a3b01ebe79a724b9e2e33aeb61f3938027975dfbd10b24d6ea699720"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
      -X github.comdaggerdaggerengine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end