class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.11.6",
      revision: "fdfde1d7cbcf0ac05f7f1c9ffb694f0da6412505"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da42d009ed4a394600b29d4fcf8c2d49d500d7398af33e7ce93eac8670dd3dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "defbbc193362c98f606fb40283ad6cc94d95dc1218eda26475bd187761fec4a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7cda07bee4bcb68f3ff76cd1bad3d71d196d61291bc931e332ef19c94cbc59"
    sha256 cellar: :any_skip_relocation, sonoma:         "4daa310ca8a6c2cb61f3ee5afaa0de8490c3c66a36f6cba2184e823219e14c6c"
    sha256 cellar: :any_skip_relocation, ventura:        "54d6496965de08e4a4636f4b16ce7139eac6140b724a31f6e43c04ea92c71c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "7695fb4834dc07602f6f3ee484e483e47b94e3715eced2577af35b9a70343f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de052c87400bf68c141fc4db9ea9b780b6480ec4c19963bdcac6d1e5140d45a"
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