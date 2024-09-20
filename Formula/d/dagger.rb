class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.13.1",
      revision: "45ebbe12bef67be185508153711b2bc2182151f2"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661ee93ddf35b30cfdad753fc5fff739f26f85764281a03cc81605e137c98c4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661ee93ddf35b30cfdad753fc5fff739f26f85764281a03cc81605e137c98c4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "661ee93ddf35b30cfdad753fc5fff739f26f85764281a03cc81605e137c98c4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "70bdfd2702a6460c18802c67899cac259bc086ce8dd339603d928a769cea08ea"
    sha256 cellar: :any_skip_relocation, ventura:       "70bdfd2702a6460c18802c67899cac259bc086ce8dd339603d928a769cea08ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f02b286ad0ce89a1628b70d6231e4378d144c7bd848f86a39fc247dcedfa475"
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