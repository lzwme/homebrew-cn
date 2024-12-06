class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.3.2.tar.gz"
  sha256 "815558df8a2338ae48f91daba2c36b0aae385c4af1aba8799e251aca48e6f39c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60bb5a380adb3889258b34e21fb25ec7dcd0c218557d48725cd50b410d4478dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60bb5a380adb3889258b34e21fb25ec7dcd0c218557d48725cd50b410d4478dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60bb5a380adb3889258b34e21fb25ec7dcd0c218557d48725cd50b410d4478dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af6976688fff13fa0610e246f5599f00e3f41c8fedde43bce8abfc654dedccb"
    sha256 cellar: :any_skip_relocation, ventura:       "0af6976688fff13fa0610e246f5599f00e3f41c8fedde43bce8abfc654dedccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b576a951528c92c50594003f1f35ec1e6adacf83b8a8769443e2478e1d01fa"
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