class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.12.3.tar.gz"
  sha256 "eb6c3581c7e4827c1c60558fd7d0543e412a5a521fc832792cf30942ec9ebc59"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55df80ccc5c4f5c2d07dc9bd6d1b2e5bfdc78b0d78b819097bff132725ff3f1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fd35b067ee435afacdf677d921b792ac9b6d1b3b58d03698cda04443c093f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7d43c371aa18ba43822dd16234388215b601b6c63488d1070243530ec4a620a"
    sha256 cellar: :any_skip_relocation, sonoma:         "82a7a9d7f0eba4408595befc29b024d2be41725f192059a44512d5f38d1d07c0"
    sha256 cellar: :any_skip_relocation, ventura:        "bdf5f6fa03b8e3a3c863957e083b96a7c853effbf5f3db3dea2655779ecf5c33"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f22e8c1c2bd33daf4cd82c69b956644094230a20c6777ccc9c9fb57e6f565e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "237f8726d8a532e41ff820c8f6239c8f467243cd783bff5055b39291c00a9e2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end