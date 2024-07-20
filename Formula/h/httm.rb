class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.39.2.tar.gz"
  sha256 "1db23cf839df0a69d9801679b43eafd98481bcd28fe5f367731e6da966f7141f"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b28c50b027495c40482146acb58ae6d81e2aa94f6024143823d2fe96fd3a1aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff4377031119e3fe64558f5dd1dcf13c33314ee14d72120909202a9fb4545cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f62e0783632b26d0a2817e804bf7f68d2072103b4225cc325d946ae30c88f37"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef0fa271ee240fe283a8454c41a78991b5ee45cd45b96d45ee30688d645c8f2f"
    sha256 cellar: :any_skip_relocation, ventura:        "b93098cf7c2d4c8680ca0dae058b1a4c96bff56ea46a71133048649a8f5d643a"
    sha256 cellar: :any_skip_relocation, monterey:       "c20edf1ab7af26c660fc469629e8d3186e8f3a64cd47fb94afda70768596da1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00708e7dd3e3d78512cbf300a2f952ae02a6e63c6148c8355ad3bf77e47db638"
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