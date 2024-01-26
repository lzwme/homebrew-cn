class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.7.2.tar.gz"
  sha256 "63eabf4cb425db06d9be2367782c1ef9ecb059585a76ccb73ab5f09370a4315e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d2494ccf68fabafb8a6eb82642f566e0f079194a4a40e7fe93a56f81da974c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fb0d1daaf6327b8f4db0ad513d29fdce9a709afd31067f89f8b0a8d5b1800b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0af3bed700a6e0d260a1dbe603a3f3d311c5bd66642e210dea42e4a6be0b06a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8da02dc0eeb0f6c933756f50ff0f3d57e56f800f659cd8e259038c0711a1668"
    sha256 cellar: :any_skip_relocation, ventura:        "993598bcc6a741bd6844218c0a2257c44d4a19950e565d041c15a9b242ddaa80"
    sha256 cellar: :any_skip_relocation, monterey:       "3696788d68dccd123c6b9235232032136fb87c57acd4f498b536b60b4601150a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf192a6ffce8f7f09f0b8e2d435b1077b2b0e6d595ba02d0c65353055f51844"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end