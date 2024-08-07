class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.11.4.tar.gz"
  sha256 "db80c54a8310b01699333090e66bd400e43553fe90bc3f7562d2b8d92f97da07"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66c23ab8831a12fc756a700a466c27666e54baacf188c9c00d72bc5e38f7d883"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428edf122472dfa4170a41e7a53256d36f7eb46a131ae297a493247ca70e5bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72df33c60ff2cbbc4c2840ce90f9f73c802b8b8d249924e962a5417c3fcbade"
    sha256 cellar: :any_skip_relocation, sonoma:         "1473c4448b977761b5e0fc0c7befa1a218775fa927d1ac101c4f18968d247ef5"
    sha256 cellar: :any_skip_relocation, ventura:        "7dd20250c6d7d6e420354f1807390475be2efcef9412e0df220139d35e094914"
    sha256 cellar: :any_skip_relocation, monterey:       "b094a676efa7a69e015f0bc28b9fbcf8b6f8d34fd9f43cfad01ca4185975ee82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce40ec28ba0111119cbb67525585e5fd929827b554e5372a5af2db52a6ff7dc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end