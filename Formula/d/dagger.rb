class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.11.3",
      revision: "d844de8d5da4e551d9ddbf890ef8c02f919c49f2"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "974f97bc5df86f9cbaf9862da7b142c329b921ffd6fd83f81f3038f7c473c287"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9105de94848b801696bab507ecca440192376e3b12dcff59bc717f992078485d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27848ff87c6bc9a0bb4c128de0e1ac8d501e82bd23212a3532c04a2182b3e325"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c0ce5e5655795c85c3a8520139e3709f1f1c3b396792cd427ab592126bf6a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "356a29bc3b7a756a4dc650e75a3050d2cc27e1e3f666794e9a2dec3d204f7b2c"
    sha256 cellar: :any_skip_relocation, monterey:       "694073f59197b53c8765e43b6463563cfaa1d49436193d89bcc60e01fe9a108c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65ba7134f1ac921ead3e207f3cb3b0eaa795c1af6984fd45f2e8bd02c408c707"
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