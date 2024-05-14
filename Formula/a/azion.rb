class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.26.0.tar.gz"
  sha256 "561aad24a56cd106d22275fecaa901221b20d0f772436494867e70ab1cea4dd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7684b48ba8cec5b6764d255e98d105aacb029e6b8f6912c027bbb0995cb5354b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "864fb0490be5235c440797e4bd74fd37bb4037483786a8dd666882d4868fce3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aabee9520c1c3a9a25895006e24fefc8ddfb137ee87dc2e7a34488fa0134e24"
    sha256 cellar: :any_skip_relocation, sonoma:         "0211a70bcbe7c5ed2f53fc89c974c27a9d1715065c9897891ae4860c38add2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "2624659447e7c14fb5cd92cd627167c669c4d4860aec26717941bcce17bc792c"
    sha256 cellar: :any_skip_relocation, monterey:       "3660e0d0b08496d9c828bdce139ed9cc80b3463903f474d32028c91602a78a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a80e6d54246588755153ab3702feda17a80e1367a9d678f2b0085c47792b8c0"
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
    assert_match "Failed to build your resource", shell_output("#{bin}azion build --yes 2>&1", 1)
  end
end