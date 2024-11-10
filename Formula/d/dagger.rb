class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.14.0",
      revision: "ec9686a4b922e278614ed1754d308c75eaa59586"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1b5808ce142598b5a873c1cd7492dbd288ea909356a9856d6c64b3ef1752aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee1b5808ce142598b5a873c1cd7492dbd288ea909356a9856d6c64b3ef1752aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee1b5808ce142598b5a873c1cd7492dbd288ea909356a9856d6c64b3ef1752aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb35d5ca77e7a6b46f1e78149c2a57a5ac0cdc0b1dabf9de5063623bab791d3"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb35d5ca77e7a6b46f1e78149c2a57a5ac0cdc0b1dabf9de5063623bab791d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593f3e2757d15a5fa6d4141f1ef2b7178f643884c616817eae55dbb4d0fc0463"
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