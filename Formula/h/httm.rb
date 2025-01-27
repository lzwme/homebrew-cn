class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.45.2.tar.gz"
  sha256 "42aa6916598f057d9e798376cb33538c3dd726edbfd41c9a1ae3a6b6a67dc645"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21cf4433365db584850929a3c14659c2b56e07e0929901177a9612da8f55c157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1cb172511d79cdc0370b6e8810f99dec6c2cf4ec762f82cfa836c2b15a657e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4cb199da358eeddec1f03fd699be225e931af2cbc874f559334762030808fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac93b42fed7d3d8ccf876fe0a4b72d7dae71ea8dd72a2ebd2f8c6813ef67fca"
    sha256 cellar: :any_skip_relocation, ventura:       "a0c153b2696dc08ce189ca72b2fd23c6b65cfab4b88f5370622dd3e2c3d864ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8e0c53137d0d30848de3a04e7792b272a2247e7db561de64a6f6861fab0086"
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