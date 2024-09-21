class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.43.1.tar.gz"
  sha256 "9f27ca0e89daacc4e5edc107e3e5e2e418badfd0d42d27a5c0e7b8acb8e4a11f"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949501334a0f76fc33b7dffc59b308147bd466b02bc2897307ff7fc6e7488f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53fafb76c72ce72926fdeafcd4cb605444495f4f071b59187402ce4152d6fb99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2350a37a204ea3f1e1f94532c2310f100c84710041dadf5ffbc797bb59d09214"
    sha256 cellar: :any_skip_relocation, sonoma:        "143a306f04312d4cd50ac095b99668e8ab2df1ced24e3f05ce8a350e34e27cdb"
    sha256 cellar: :any_skip_relocation, ventura:       "d0b05dc16f66de18da5e4e3137ab64b76f6b51e0a3d6f6206f486db3f3e88e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7625814d7f3e941ef4a2b65b04c2054b9423ae3030781a0edf95a44776ff2b41"
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