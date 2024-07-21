class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.0.tar.gz"
  sha256 "f7e7b3f73dc26e42aba82fb69ff3c9fafec000d3e6df383defd7e40590068bde"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a0307d8aaa25c6f253cd5faf2ab7778f5af1afd0b528dcc3d6e6a7ef37e9a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb36c0df65c785764f5d4a80dfa29accbd6f63a938f9e7882c56533c8b8b4903"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950c86d6f01a3fe6c4e89b0ccb28c7622860d2be70d27e568ceba21cde38d2b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b08576c78977b3eaf839483881d78945ae1161c269220b4cf3ba06a9c37f66b3"
    sha256 cellar: :any_skip_relocation, ventura:        "f80d7d7d9d237972ee343ba562db565f62e02ec580b3f8a0ad5c4a46077f3f24"
    sha256 cellar: :any_skip_relocation, monterey:       "71d776acdd9fbb9af1a18bd1ffdddb58c3955c765d8d5a3d983755baacd8e6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756e13fa659f435e2a727f8dde34211039b09f4e46f2f4aff8add1d5984530a2"
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