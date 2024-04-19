class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.9.3.tar.gz"
  sha256 "09464a08b4b52223876ce2077c58c7af1e1dee4f69d99cfc917bb2c173b83d01"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9e5713a3aac6e470f6fca471af37e8fff3f096286791d178b2bdff1482dbd45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28c695553ade8dad67520ce138a0631b36f24cc21d1e15690a96a786e28a378b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8f2d2c2c59c4b8a51983cbed7ed5457f69fdf4a1aa899c4c0af61b0f687a8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a02831c3632b62b177cfee0ff9643d8f0df16057532a1bb90122c5d6df24783"
    sha256 cellar: :any_skip_relocation, ventura:        "496dd59016f3a36e45f2a41e5a16fe5eb7b0da25ce0d44ceac4b2cef4299324a"
    sha256 cellar: :any_skip_relocation, monterey:       "398187b1ad2054fe5e0ff85f6a56e98a260118d7a158dac35a985c72e93dd46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "698cc24a0dbab67aa3096ec177a1ab5fb8c8289414945fc81674d436a78795ab"
  end

  depends_on "go@1.21" => :build # see https:github.comcodercoderissues11342

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