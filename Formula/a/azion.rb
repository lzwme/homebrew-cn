class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.7.0.tar.gz"
  sha256 "7a0aabce00f54b6bbc1f8f725f8b18d69c510e4d026d21d4fc1b8773584ad85e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6f901f3c0381531b10997b8779c07e10557222533fce354501f8559944c4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de6f901f3c0381531b10997b8779c07e10557222533fce354501f8559944c4dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de6f901f3c0381531b10997b8779c07e10557222533fce354501f8559944c4dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba8b093e79047ae804d4ecc5166fcc9f8bbaf7a3a81b73fdbe693a4b1fdaf50a"
    sha256 cellar: :any_skip_relocation, ventura:       "ba8b093e79047ae804d4ecc5166fcc9f8bbaf7a3a81b73fdbe693a4b1fdaf50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373808806bd5080de9e32e845b9b5426c61958bec12fc37b3d00f4fe51436cf7"
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