class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.22.0.tar.gz"
  sha256 "75b4a525e69fed2cdabcb8f77b6eb8bda5f00e8e01928d9bb126311584077004"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e09d252dc35d8fbccc994ca71fbde3a1f968a1ca8f26071f0477facbf1cd550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2dcc7abe7931f532cb8458173caf7a0b9107d346547c798aeca1e9e262d437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca2cbb6ac7901c4892816f9ad31f29212e087b41d41c80f53201974217e32c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8cb20a1d9af9dc9ac2101098a03f6b1f57df21450f50d646baaed6266b4deec"
    sha256 cellar: :any_skip_relocation, ventura:        "e6811fad5e480d40da0e86e9225063989d29bf9be48f0e4479e4f5eff73d14bb"
    sha256 cellar: :any_skip_relocation, monterey:       "81442d9d2829ff7e76f7aabc1f9b059de53cbf908aac67fe7b3b2102073ce3ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e597ef6c347a14b8313cda96841e552c20790e92201a43f32641dfdcdcd97e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaziontechazion-clipkgcmdversion.BinVersion=#{version}
      -X github.comaziontechazion-clipkgconstants.StorageApiURL=https:api.azion.com
      -X github.comaziontechazion-clipkgconstants.AuthURL=https:sso.azion.comapi
      -X github.comaziontechazion-clipkgconstants.ApiURL=https:api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion dev --yes 2>&1", 1)
  end
end