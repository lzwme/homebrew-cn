class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.23.0.tar.gz"
  sha256 "b2b4a848c025579a2092a1f755ec4a36affac0a286c7ed83432bade6bc07c2e6"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79a454681ecd6fb0d62ab86cd304f55e173ca6136baa2b14e965c8f82672edaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "118e74180a22c4a130a4686c028df98dea668fecf0c1f242d714891b0d009758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d6581d3f007ff23f11cb58eee6f65e6b65f6865063de4813dbb4e2ec8a391a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5ba9b621a480bad2dda67555fc6d2e0719bde8ee19cd1a1866a561f3f63ccfd"
    sha256 cellar: :any_skip_relocation, ventura:        "cc84e4a9a44ae6d3c61f68f0a04a1b6e3c5f329e40b5fccfdc546d1b0df761ba"
    sha256 cellar: :any_skip_relocation, monterey:       "76172e6080e3bb53ba354f4726ed888acb0ec8fa39292d6f3bd7f75f320162b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "795b2b4ecb12ccfabe0c00a2613606817615d629d6c5fef746caf46942221730"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end