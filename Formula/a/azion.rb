class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.5.0.tar.gz"
  sha256 "6b6f75d233b5c0ce57ce83cc0e5adda9835f7e0fc26431af9fe875fec51df797"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9fa77c0d34894fe8ea7ba00c47c1fdacd4dd53b0fbd7ea596922552dac1f3b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9fa77c0d34894fe8ea7ba00c47c1fdacd4dd53b0fbd7ea596922552dac1f3b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9fa77c0d34894fe8ea7ba00c47c1fdacd4dd53b0fbd7ea596922552dac1f3b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "399c9821729dee13e07fd13d99618176ffb0701bd8c7915b0436a60fabb64f02"
    sha256 cellar: :any_skip_relocation, ventura:       "399c9821729dee13e07fd13d99618176ffb0701bd8c7915b0436a60fabb64f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e487617c535bb055e8f76ffed8cfea08482fa931ed9f81fe3380c9acd89a1b"
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