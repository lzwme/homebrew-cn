class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.6.tar.gz"
  sha256 "51c2eba5cde95174a02811830a29e697f6092677e7b1b41843a741b88ba493c9"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6800bbba50930a851580a1292d7a25e62ef904f7039fbce84ae4b850d4e95bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "506ef4ffc309310f3744ccafb4c433f56150f01ff840b214597d7ec4a4cb7b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbdc9bc161ba2f01a681a5284c18b9aafa164752c0fb74ec06c79ba809834a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "282317c70bdc8bd38a76f29b6cdeea1117b45c30522944bf2efef68a115c7d66"
    sha256 cellar: :any_skip_relocation, ventura:        "f76ed335cb8103f3bb10e176daeb36ba75640831f7d498ec94dbe3bbcf4bfe27"
    sha256 cellar: :any_skip_relocation, monterey:       "47dd850030eb266a18a6e469416ee6a03560fe99f984f5541c66599849978bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9dbf847ab005764e189a3e55f93cde35a2abe1e37fc06dfa1598148f458ac4"
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