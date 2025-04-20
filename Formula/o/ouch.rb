class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https:github.comouch-orgouch"
  url "https:github.comouch-orgoucharchiverefstags0.6.0.tar.gz"
  sha256 "508f627342e6bcc560e24c2700406b037effbf120510d3d80192cd9acaa588fe"
  license "MIT"
  head "https:github.comouch-orgouch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dac8830acd7a35d705e224933ef32c5bfb951cc38574b467b9090198cb696ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d29680299b28ff96acec040e75f71582d4f0d219fbeb3143e16e1094b8ae1b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea048d23715f30a3c80e48ff8eb74201f47e867598b01c8dc0ecc801498f13f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0276b1474c09480e1bb44e743138fcccf0cbbe8f8f48bf72e82ba1e734af2a01"
    sha256 cellar: :any_skip_relocation, ventura:       "c0e96794643f64bdace58f62c79419ee40584f7bc7df4f655007d1824c4f5951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06f1054814ebfb5a6a1220e85d8ba3e8df5a30cc807c68b9a602c7c63f6de830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3426a89731da1626147d43cebe2dca36c783c6630826122e9c7843cfe75eb1"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    # for completion and manpage generation
    ENV["OUCH_ARTIFACTS_FOLDER"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "ouch.bash" => "ouch"
    fish_completion.install "ouch.fish"
    zsh_completion.install "_ouch"

    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ouch --version")

    (testpath"file1").write "Hello"
    (testpath"file2").write "World!"

    %w[tar zip 7z tar.bz2 tar.bz3 tar.lz4 tar.gz tar.xz tar.zst tar.sz tar.br].each do |format|
      system bin"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_path_exists testpath"archive.#{format}"

      system bin"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpathformat
      assert_equal "Hello", (testpathformat"file1").read
      assert_equal "World!", (testpathformat"file2").read
    end
  end
end