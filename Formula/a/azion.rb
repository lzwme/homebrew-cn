class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.37.0.tar.gz"
  sha256 "bd9fa95b7317f4f4e448882b8100cd4718dcabe751ac960ed364ab94fc0dd229"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c1588b7faf9995e6ddb8e19981da4fb614ab9329a3e632022a45e346f19ed72f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b29bbe26b0048580b4690b8204221e4a0746394a37120a075943267b9bee4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53b29bbe26b0048580b4690b8204221e4a0746394a37120a075943267b9bee4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b29bbe26b0048580b4690b8204221e4a0746394a37120a075943267b9bee4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "edf367a2c4a1d351893df64f393c049a7df11d1c0426fd79b9f91d5f116d7ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "edf367a2c4a1d351893df64f393c049a7df11d1c0426fd79b9f91d5f116d7ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "edf367a2c4a1d351893df64f393c049a7df11d1c0426fd79b9f91d5f116d7ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c456c5aaaeb6332feb5bf09e794324772f75b084db8e1109e32b889d8b9e90a"
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