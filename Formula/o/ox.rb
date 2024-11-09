class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.7.0.tar.gz"
  sha256 "921b1210f9b750f10480f0e5b9ed761d9cea063aedc9eb59e66a04664e04eaa1"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a09d83cfcd0ab82baba4cd92d7f53c7a73c1b969f1491e74b8d6b0f90c15dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158062947457fd64f569cad4160116871a6a6476aee46c7d09993bc580fad5c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab423897c4ea300f3716a99ae578d88c49559b568be78808e44d4847cf06aac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1149cf78c2b1de630a6fc968dddf4241e74a747ea94f9dfc143f940e9dac0329"
    sha256 cellar: :any_skip_relocation, ventura:       "601368f888c7c58e175a745f95f1429a9b298b85ed2afe2440b7caad327244fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ba179e1fb335f6ef421444d3d321d0bfeb7bc7eec2844ec4e6d9b2f2620824"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end