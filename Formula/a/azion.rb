class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.1.2.tar.gz"
  sha256 "b10a102faea70a1e66694051be784e5c44bc7d2a52b063b909945c53b403011f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e2220c4646bca05c25500bcdd967f86c9fd9ec0163db248ac3adaaf704b9253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e2220c4646bca05c25500bcdd967f86c9fd9ec0163db248ac3adaaf704b9253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e2220c4646bca05c25500bcdd967f86c9fd9ec0163db248ac3adaaf704b9253"
    sha256 cellar: :any_skip_relocation, sonoma:        "7da829a38a1d08bc550b96581167ade06bd7e5c0f88ebdbb6b4aeba85f89ede6"
    sha256 cellar: :any_skip_relocation, ventura:       "7da829a38a1d08bc550b96581167ade06bd7e5c0f88ebdbb6b4aeba85f89ede6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c597907091892a2ae2e4e6511e30b76cf104c15a6f162c83d3234f8cdc65eca"
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