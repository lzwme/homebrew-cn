class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.9.9",
      revision: "ac1e2d796e8cb2ea34de4fa2ed7789cc6d2b35d1"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "229c8860e584e23e117b6c322148ca34fcf2890da2447846ac083913b8f410d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7105969dda9b6080cc34f2c8056352e20bef5edfe8ff569a51e8fd1ded9d6e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95da3845d9415073c9dbdf2bd888efad81babe97bcb06fee6f2912679f09390c"
    sha256 cellar: :any_skip_relocation, sonoma:         "54ab9f00e7ba84125a59fd099d4c9f7c241cdcad55960d6f8488cd4111425c4f"
    sha256 cellar: :any_skip_relocation, ventura:        "9292ac01404af704e4631a2b79c42280a1430b8050ffb86bdf2637f5cb16e313"
    sha256 cellar: :any_skip_relocation, monterey:       "2ffb2ce8a8172e8d5e29488134704604943e8dda461aacbe4a0b245727760188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640355fe9f6c74caa64ff634f307d687f60767be0396ec7cc264c4c94e93e925"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end