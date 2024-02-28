class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.14.0.tar.gz"
  sha256 "7c2323f944772913a5f37471313a37bf390fd71beddc02cc046386503187b97a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a62116f355e8cbaf6ef7982f3321dfca7ac7998a488c95e61dd882ab80392323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3306bcc9e0ae793e58072274ad459dcc7471a445aa8f0d5d0cafd5e3c726ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741ebffbd69337403215818d09f1889992d44feaa562595f3a51ca7fd4dd1aa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8127172510eec540ff2705a76ebbf9e7e46c0d6d02c6f17a9aeca1c9037009c1"
    sha256 cellar: :any_skip_relocation, ventura:        "f5b619e66d18c7113b010a8c89503d93bb1fb58251259c600c4236491dfe9d8a"
    sha256 cellar: :any_skip_relocation, monterey:       "d53db5b9436881092c9610ce8c860152d3db6fda94c2e7352ce3ac5f449e5a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e14b0c48aae70f451f860995603c71391fc73fcdbb75be50e28b06d98026f526"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion dev --yes 2>&1", 1)
  end
end