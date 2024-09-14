class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.43.0.tar.gz"
  sha256 "1b0c988bc594c0413cb8bb996f55da44f2f15019512778f31769be2d69cd7b8e"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09240c4a7634300c8d91eae95c169d625d870aacd05e649bae92906c54894d40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71594837886a453b06af8c9279c0c742a2ba68419b3fe12522c090bdf6b436c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fee84ac006acddcb3918ff1c906c6bc15448a54481086e59025458d948cdc89f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79a2fdb70f8a7333df014f93461c506258443041e60a936c4c4ca6bf341df854"
    sha256 cellar: :any_skip_relocation, sonoma:         "27bca59e20f3b54cafd4372fe051b5d4f86ef5c089b6e4652ee7153871ab5c86"
    sha256 cellar: :any_skip_relocation, ventura:        "4a1fa423d1d20b7cc5657ef5bf61714f963a72bc55e589992bd3cc1bda228c24"
    sha256 cellar: :any_skip_relocation, monterey:       "d89512b97837d60175400d58b585e8b95b9350d9b027840340e78a50de731090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22c4f22ac4e798dbfa359cf197d36014fb7668fe673b7ecb1fcf7e07b51544a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scriptsounce.bash" => "ounce"
    bin.install "scriptsbowie.bash" => "bowie"
    bin.install "scriptsnicotine.bash" => "nicotine"
    bin.install "scriptsequine.bash" => "equine"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end