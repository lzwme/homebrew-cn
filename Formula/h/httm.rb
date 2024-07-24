class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.1.tar.gz"
  sha256 "4f1f9ba901ec01c53f813bdf3e2fbe182cb4fb1bd4063fab0a0917251c38bd92"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "634c6b067c9c801ffa523d2c2ce5aecc85ef606000e439348b785c1f9d195ba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d81c2ad1bad295215397f18e10f81ec9510f1e8966b67540c815a8eab5a81ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2de83506123bed1c420078d6458fdc8a577e5c093949b7da4a9cf8bca31f3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dad2eb85b8ae838732d162e5e7883b3d96c028b22c3fc0ccf6b80ac624e54de"
    sha256 cellar: :any_skip_relocation, ventura:        "d29d81945e2db08633304c54509f1f4f9f0c8e3bc21faeb319ae641665290296"
    sha256 cellar: :any_skip_relocation, monterey:       "ede6ebd36f272607a5b80998cfeb8a802747dba3bc8931b8267d210fdf450dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b345739d88d6085e4a8ad4bbf175d8353495582b42fe8f675038d2f1bd0578"
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