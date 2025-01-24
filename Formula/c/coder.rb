class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.18.4.tar.gz"
  sha256 "2d6648c34dc6f5915736d9c817fb69aecd6247c370c25197cc4f13ad56c99660"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd6ea4c6d31a4c55fdbf922d2bef67cf29a242d396f20d1686b1d086a929088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6be2202c99e9bc3c4c2d7ad4ea328e126d041fe3a833b8de9a071203fd8e510"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7acfa5f859df85eb609d001ce033a442f1c5f5aeec2f6971415e89fef199fcef"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a20b6bafc5bdd9f3fe2e9ed8537c1a2fa155fd97f09d3a0c8690aab88b0f1d7"
    sha256 cellar: :any_skip_relocation, ventura:       "632231755d2f3a59521b7b7c6787a446afb79e6d61ec14fa1c8a39ecab33c92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a88cdeb489c40a600c94176f02938becc19c80433c1d68d9dd1b2ff8d126dd41"
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