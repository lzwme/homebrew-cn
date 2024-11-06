class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.16.1.tar.gz"
  sha256 "49f762079956f21288404dddb8da89e66a33878bf7d73f0cde30f2af0180395b"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c3947d13b6264dba6660187c4b66795154cc67a086dc86c2894127e0827b6d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "261d10e297e215bc25d5638ff1e9bc9c9b363c737ef20febe836153c02cd5c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f48aa8cfb123fb4e72519e6dec6521bc6093d70e43e7e404ad63f52896c47955"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8305067bb0945185a688be8b213c2423d7ac0fb8525b037ffdfac48b177e42"
    sha256 cellar: :any_skip_relocation, ventura:       "a76b6e60c9f08f3ec25b99067262bccc32c0011046c6117c9a0b5c5c70e6c91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b947d5de6483bff4f009c198ad2d26cfeec0606f5f0b84793a69e963e0fde4"
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