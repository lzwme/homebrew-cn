class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.13.4",
      revision: "b35757b05ff35243483dbc6ab0a3cf9a95b41b59"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f1ef80f831954d6db95609969f3a680c981e12f66df96763522172ae017125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f1ef80f831954d6db95609969f3a680c981e12f66df96763522172ae017125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f1ef80f831954d6db95609969f3a680c981e12f66df96763522172ae017125"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a195dc10a58c3602fbc55c7e8d3b9b1f9047bfa7422d5f121f7c2cd7fc4b625"
    sha256 cellar: :any_skip_relocation, ventura:       "0a195dc10a58c3602fbc55c7e8d3b9b1f9047bfa7422d5f121f7c2cd7fc4b625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7419ac6edefa9b53bd9b8dde0ceae0b1b715054860b2e11c3f4f690f07d553"
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