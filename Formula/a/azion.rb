class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.9.3.tar.gz"
  sha256 "7ea133af95ffea354915ccb766c198ba166194a00760c93e84dda76d5beb128e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "594660528cc7212300d133a45a35307cff95f8bb7849af54437916118facc3a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9af7140c5d70ffbed6b9e6268ba6cb7164f9f004a7010dac39b36dbfff6308b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4986511603b27b258c6f4feba2b87525ac483d9f62e9e1e7f357975bde7d5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f33024e521913d36e778b7a98e029e3219ac6686406b2f998e81bf1036ec8204"
    sha256 cellar: :any_skip_relocation, ventura:        "735dbb80d7858036f845cb7284cde106cb234eaef68a18b7ea3af19a7a3925ff"
    sha256 cellar: :any_skip_relocation, monterey:       "0901ded6446c3fdaf34d00cb9cdf94934512874b21e03d40f982b99e73f4505c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7cfabb46b67ffb51c1fa4dbfb1599dadb83c3fecfbfc48a44abff920c9a5120"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end