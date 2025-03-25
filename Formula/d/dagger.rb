class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.17.1.tar.gz"
  sha256 "17d864c7c391d9c984be363b04a859659b40b1b71f5c4fe5bf502fd0073671b1"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949accb8ded429f2c2433981cb4df5f66bb1f450160a0e447d382b5f2879f017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "949accb8ded429f2c2433981cb4df5f66bb1f450160a0e447d382b5f2879f017"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949accb8ded429f2c2433981cb4df5f66bb1f450160a0e447d382b5f2879f017"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7fa12deef26ddabcb323719c48ddd6ea14333237c3719790170f3df0435899"
    sha256 cellar: :any_skip_relocation, ventura:       "eb7fa12deef26ddabcb323719c48ddd6ea14333237c3719790170f3df0435899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d612c08c3c6774cbc96eeaf58e14cbf4524b556ef5821e2e91cc8618abf32958"
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