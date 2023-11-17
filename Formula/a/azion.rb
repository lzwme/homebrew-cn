class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.8.0.tar.gz"
  sha256 "a9ef07b2407652b3559dce8044ef4cad6b4aed1b3c290e98ead8fb5842cc0f5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c762ce57a733d34fef7fff2ab36505561be4e5ab00ecfe628b763818ac08352"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4aba414aa9886c5f4937fdc5ad8cb2b7f289e3fe21074ea7a02a988b1fb56ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03b9ccba4887eae46cfcc046a1dd45d4d1674334d27136bdb6dbe83009bce70b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6fcf9a9888e6bbebf8944dc216c782629b5effd20e93f4e47c8fb780b9cbc14"
    sha256 cellar: :any_skip_relocation, ventura:        "7ffeac080e12e578c78f6e6f83c811d6fee8c75cfe75b095cb65aedfdd1c267b"
    sha256 cellar: :any_skip_relocation, monterey:       "8439822d993f7045f8c7dad32d761def0ab240922d3db3685a849e112bb09877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eefa8efdb5289390289f325635a362360132798de2ae1144bcb69f206de17ef4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
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