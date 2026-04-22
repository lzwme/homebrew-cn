class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://ghfast.top/https://github.com/ouch-org/ouch/archive/refs/tags/0.7.0.tar.gz"
  sha256 "cbcfbc41cabfaa562dd7f8ca556f981d85612d3b1d457c00ea1b1ee59e19fb79"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d483a9124afc4c5c736bf3a1c6724ede2824d815f206204953b6a1d812040418"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7a8ecaf42f8086c5fdceaa2168a8fa8fa0917dd65bffe8e1c641e7739c7037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e166f9d8fe8ef6870c9b5780a4bb268b66ec786278567b084c4dba2c6b528b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4642c181cbdf40c9144a78c499af10d711632d7af6ced9f1b110ea8d32ed12c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70a5f54862d62ba95cb3f71c6d29073b6f0e6fec60ccace0d518fcdd2eccbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "339091bbf0e8593fedbc6377b004400f878ace94ad4636b3341203928b6c4608"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround forgotten version update in Cargo.toml
    # https://github.com/ouch-org/ouch/issues/954
    inreplace "Cargo.toml", "version = \"0.6.1\"", "version = \"#{version}\""

    # for completion and manpage generation
    ENV["OUCH_ARTIFACTS_FOLDER"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "ouch.bash" => "ouch"
    fish_completion.install "ouch.fish"
    zsh_completion.install "_ouch"

    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ouch --version")

    (testpath/"file1").write "Hello"
    (testpath/"file2").write "World!"

    %w[tar zip 7z tar.bz2 tar.bz3 tar.lz4 tar.gz tar.xz tar.zst tar.sz tar.br].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_path_exists testpath/"archive.#{format}"

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"file1").read
      assert_equal "World!", (testpath/format/"file2").read
    end
  end
end