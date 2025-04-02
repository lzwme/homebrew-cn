class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.1.tar.gz"
  sha256 "ee254abaddf469fcf904451f962a51ddae0d9e78acb2b522ddafb29da8e0cafa"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea66e6ce4a7ef664385a1789f6b7baeb175b2be82f8e4c3b3457fb491da13308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea66e6ce4a7ef664385a1789f6b7baeb175b2be82f8e4c3b3457fb491da13308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea66e6ce4a7ef664385a1789f6b7baeb175b2be82f8e4c3b3457fb491da13308"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8d9df66c708fc79aa5e54902cac2a2cdd83e2f5fc385d21c7f5b454b6f74399"
    sha256 cellar: :any_skip_relocation, ventura:       "e8d9df66c708fc79aa5e54902cac2a2cdd83e2f5fc385d21c7f5b454b6f74399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2fa97e11291f49fe8715f45cf5deac448662ce157f778ceacf2e339bcfd0ed"
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