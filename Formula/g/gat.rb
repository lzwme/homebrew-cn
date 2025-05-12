class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https:github.comkoki-developgat"
  url "https:github.comkoki-developgatarchiverefstagsv0.23.2.tar.gz"
  sha256 "da1ed0c5bce7c5fc23ddc3996b7716baef361d64a38cc26dc8749511f7aef2b5"
  license "MIT"
  head "https:github.comkoki-developgat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d16c36137aa83ea1178baf17fcaf1d4f6314a823d325785c3bbcab26b29ab2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d16c36137aa83ea1178baf17fcaf1d4f6314a823d325785c3bbcab26b29ab2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d16c36137aa83ea1178baf17fcaf1d4f6314a823d325785c3bbcab26b29ab2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "73244cf766606d7a54433593f594a4cc1b0f1edd1f238d3d73654e5f89b3096d"
    sha256 cellar: :any_skip_relocation, ventura:       "73244cf766606d7a54433593f594a4cc1b0f1edd1f238d3d73654e5f89b3096d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f99bbb6799cca56f700f95db4434c947d6addddcb659937b97666ffdbfa57e4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comkoki-developgatcmd.version=v#{version}")
  end

  test do
    (testpath"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}gat --version")
  end
end