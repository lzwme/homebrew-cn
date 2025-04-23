class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.4.tar.gz"
  sha256 "94267f1ac5d94565d33fe599875634a586586eda7562812ba1217889b4b52918"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7068dfdadae70b2f7fe4b28f1e295ec3a3399a7c57b45ca64a59ed165ad38521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7068dfdadae70b2f7fe4b28f1e295ec3a3399a7c57b45ca64a59ed165ad38521"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7068dfdadae70b2f7fe4b28f1e295ec3a3399a7c57b45ca64a59ed165ad38521"
    sha256 cellar: :any_skip_relocation, sonoma:        "342dbb74d9e6fb50b6d588bd2741a20c45066633fe1dc6fe4796069d9af6f0f6"
    sha256 cellar: :any_skip_relocation, ventura:       "342dbb74d9e6fb50b6d588bd2741a20c45066633fe1dc6fe4796069d9af6f0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c365b6569326285705c5b51685202576de38bed6df92fe06dd66f78404464fd"
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