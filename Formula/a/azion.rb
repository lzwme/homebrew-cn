class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.9.2.tar.gz"
  sha256 "8a4ab32e1a598e76c51625cb8bc3436ee2f1b736454e150209214c78a3fdb1ff"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1228f60791161b7abf28849f696fabd205124894db1dd6e194a1bb35fadd623c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ab9e9f38f574c6dcd8a6d9c45cf9dc3409caa0f182359db17fe6000966b60e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47f7ea652f47e627fdd3aaf920246bd57029a14d402ef7f3d1d8b0942907392"
    sha256 cellar: :any_skip_relocation, sonoma:         "33965ff908d7fce890e989dbb6effed2c9cf8eacf2311094118e8a9881a36c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "5b65813284dc941d2fce65aeec0fa30518bb51562c010384b55b9033fc5f6e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "89a5cb7712acb71bfd6252ce13c3bb49a94e94ee8448c82d7a4dd34765bef170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdf0c3c251d5f089805e1c618a685df0ab7ffc5292a5d362eb13c7eb0ada064b"
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