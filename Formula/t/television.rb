class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.14.3.tar.gz"
  sha256 "26e5fc813034273b8740127f384619e89bc3ba1d2c496491ca0fdfa924175eac"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5073e35ab90c17044fd19886353a9c028a9150d7ee6792c1cb291ae0b6db59f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a06dd5cd6e2d04af9250cd801c26525da5c3df2830ebdf015b57405962065ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79e6b3692b432219ea9d7fa4b0fc30a7be27c596c2d612460ddf0c37533f1a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "87748672ce089c55d4bca1e9dcbd20c0e716efe3b00f873f75c2f2eff77128c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b38f1f3d8b973b08e46c75f5f827fa4a586474302e43f98b497c2d610d1de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4398d9107ed6694fb47f98a5c1e14e97c8cf4bf807a2e9fd63e597491d49245c"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end