class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.17.0.tar.gz"
  sha256 "03e6f82a6892664557f26970158504c7879c3528c8d455d6827c0ec9d6870962"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ed86e8c985b96cc158867dd361dcd7e4ac1b7f2d79a7cf58f34f759e0cc8f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ed86e8c985b96cc158867dd361dcd7e4ac1b7f2d79a7cf58f34f759e0cc8f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87ed86e8c985b96cc158867dd361dcd7e4ac1b7f2d79a7cf58f34f759e0cc8f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eacb5635c16b44513bfbb847d239c0b116fa0d199c6d874c1043cd1d3536f843"
    sha256 cellar: :any_skip_relocation, ventura:       "eacb5635c16b44513bfbb847d239c0b116fa0d199c6d874c1043cd1d3536f843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a595fec4d6b0a4aeba4523e07329601fe554dbd210c63306088b1c302696329e"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdxk6"
  end

  test do
    str_build = shell_output("#{bin}xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end