class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.11.0",
      revision: "fa782c5f25e178e20d58cb7e9610f89bcd38e8ba"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "107e31395fc22af4491d7d6df1f78d291705c87f200bcf0a07e139f1a17c6b24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff5d482f58dbd09a9149485a08592de3a9cbd5a334dfb2598412bf74e2daf43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "018d6ce9d8c9946d205f5234562d4817238ef51fa30695d1a5010c5190a41784"
    sha256 cellar: :any_skip_relocation, sonoma:         "21c98a3ea631e63c42f95ca266d18b28ef3c7be9518b6c4a363239370f377254"
    sha256 cellar: :any_skip_relocation, ventura:        "2a6a2a620179c151c344f2537a7f8543238cdd0a07eda10b2e4e0f85e1690249"
    sha256 cellar: :any_skip_relocation, monterey:       "14db2484a1d9dadae89436ac0a3dc2d43c4774ac51af8ff6480f844afbaf1201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a45a846d1bcb36bf2ade869482af50ea3c53f9f916489f3b44ae4da714f5ad"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
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