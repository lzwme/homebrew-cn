class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://ghfast.top/https://github.com/ouch-org/ouch/archive/refs/tags/0.8.2.tar.gz"
  sha256 "803dd9d0bcdb0b4f94336bc1e9fbb5c878bf2867e03f58f266adc679c224698d"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c85a3b5390d7c9aff92af0a957c165e4d576a8140d30b8d52cb723d29625f5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d606c466e1dcac3e5eb97d5c82789b39c2d7d7027b1a062300425e84fa2b79da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70ee7f504055225c9a286ee00559b61d15b6feeb11ffd00f44c8cd4bc04b51ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cc1e26f0d4a8fe6ae7e54df750956c2b9c017e4f6e2a27cc69b5b9b262e675f2"
    sha256 cellar: :any,                 arm64_linux:       "bdc03aebce279f0f3f04fc48d78757b0a6111d432d4bce84235a29869c487ba8"
    sha256 cellar: :any,                 x86_64_linux:      "3b2f3e122686f91ade6b80ac8fbee6538a031fb827fb6062659f811c7d7ed136"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix the reported version, upstream PR ref, https://github.com/ouch-org/ouch/pull/1071
  patch do
    url "https://github.com/ouch-org/ouch/commit/887fb81eebb816809971f7b30b8d8e5f65b03fc0.patch?full_index=1"
    sha256 "d1036aec38d5818f811a5fca849db7ebe5226e2304fec091676399b144f7a38b"
    type :unofficial
  end

  deny_network_access! :test

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