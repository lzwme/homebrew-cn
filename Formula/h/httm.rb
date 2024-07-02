class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.39.1.tar.gz"
  sha256 "fa8151768ebb7e2667ce454fc74cce80cbc85d168cd0c05ffe6349c791e75fb2"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edd4f7d77f4a215c11e7663d55649d6839f0b12865077e18cd42876416335ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "421a57c485b9c4282bd5d096774702d5e4a451fe1ea76045eb567383b31061a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8808149b9c79deba22adae701464dbccef4611dddb1933e44f6279736a6fee7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9139d1bfc3749ed44ab9c00b7a64ab81c134978c99444373b515bd54e3189008"
    sha256 cellar: :any_skip_relocation, ventura:        "6b5d9e942612c0838e98dc63c6b9fad9553f97160af2f90d1f95ac4ee92f9d93"
    sha256 cellar: :any_skip_relocation, monterey:       "7db1cb7d23257475f25b5698eab59d2a5644ec9f7258204ae0442f84a7ded141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8055b25ec19eea3e3d76b101b973188abb54a09aa6c44cccfcd478c4999e1d3"
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