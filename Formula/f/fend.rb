class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://ghproxy.com/https://github.com/printfn/fend/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "90364fab29b51e1c359ff72f8ccfc3e8a3c96bbc8b38d0646c28c489a8071084"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc1a9ea4dbec7d357b696cf66f598455827a60de54ce05c51709777997bfaccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71cc1a5553c68e529865cd33f1b53aa0870fc68274cd11a47a012da68feb4846"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94a6fde030849242b1de338cfa3ef2e4be70bdcd937351052c9e8cb2135b8e30"
    sha256 cellar: :any_skip_relocation, sonoma:         "323bdeb36240d66a9106aac5d5319762926eb383eb3a07805ae2a793c9729d96"
    sha256 cellar: :any_skip_relocation, ventura:        "cad4f51101953b00662d61a1c007dc7d16d614a5661058fb440019de0d801494"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a754f2c39fc755306d43be3d079062b8aa3dc6eb74a4ba9a6d40802dd7e3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78be40260e51f424513933c2e4098cc2402dce842689a7fe5c974e2600df0655"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end