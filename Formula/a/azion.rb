class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.27.1.tar.gz"
  sha256 "b659453db78f4e6a43ba09dde60e74780b441bb58978bf770c115cfd7988fd93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1c0cac194779e8bb3044e45ff046fc100259093d6b219f10f22037ad44260bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e06c99b0197170130565b95ef7c2fa5fb24888d30ba00782687f831e8b84e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a574df5ff6b45e36a56a0506727e43b47fcf20c65df0b962bc87d016c9acb16"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aea2f1e35273ca720a538e40a0df79a20f5e65850da6b7c10d2d84a4924a981"
    sha256 cellar: :any_skip_relocation, ventura:        "b941a38a3003696e15cd2ed34913cdefb6c2732465397391a97c57644925d8e5"
    sha256 cellar: :any_skip_relocation, monterey:       "157e6b0176b4437f96c20554c771b9058e72285570e0a7b42819d07dd106d4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1c16766bae1a41ca0dcce9dea6f79556bee88f285355fdd914483eaf8b2b3e"
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