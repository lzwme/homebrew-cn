class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdaggerarchiverefstagsv0.18.8.tar.gz"
  sha256 "40af9698750415e4100908156fa1b705811c482dc109257afd4af6ccf6f4eab0"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c4e9cb80d508a4dd000618100b2bc694f7b0e8c1cc2f92e3c01a7dd467cb36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c4e9cb80d508a4dd000618100b2bc694f7b0e8c1cc2f92e3c01a7dd467cb36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5c4e9cb80d508a4dd000618100b2bc694f7b0e8c1cc2f92e3c01a7dd467cb36"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbfc058cc6313bc4feda60f4351cf53286d682a3750b92211a91f733fb5f3d0f"
    sha256 cellar: :any_skip_relocation, ventura:       "dbfc058cc6313bc4feda60f4351cf53286d682a3750b92211a91f733fb5f3d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790bc376851869cfe7ca735a0b52bea6ad1221f86a6de35243204aeb69af5046"
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