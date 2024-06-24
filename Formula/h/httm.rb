class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.39.0.tar.gz"
  sha256 "0f4127ad00f5a7fe660882575fe6bc18be7410ebbf66d3ba97f56d862671137a"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc0366df515e0d6b0e0c238b32b2733b1e28c50e456fa0d4e0bfedf68c805a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e52a0ddeceebbe632c3f012df4d26d1cd4c5a1f71a550ebda05e83361171b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f37b836f31a28a102263490a7aafb949bf931dd199b979bc6919928ec8b378"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3afe4296c39d2ecf14e7c197926ffaca2cd94e918f908d395dab6e95ad44b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "91b6f662e53dee50028a2065293e87ef86714c7522f84b817f04bf199051a645"
    sha256 cellar: :any_skip_relocation, monterey:       "36e02c14b4de986875692a995f449fd720bbc92afb86a4d61e694ba2ec09f23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc1835dde88448e076a55847e21ccdcd82b4d32166de73b2dff9b53e4f4966c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

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