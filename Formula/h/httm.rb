class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.42.1.tar.gz"
  sha256 "125ba14bc38b8b50261b451b0bbbcadf17a121192ef5b6be885ebe5cb82d3a13"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e19bd32b551403247b3c60ae1b236257e1dc2c643933fda85d122f8dc07546ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "342ca42f55ccc022e796aecd745d132a50be987bfa2818fa5ea4acd27f463830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb9de3ec32809dd70abb0d8f70069c6a69f9cd4c686c975bb96efa8df79edb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "13387a88d3bc3a5666d54ce71d2f362149f0aad0c9f09869aa3b576f4e2b7dac"
    sha256 cellar: :any_skip_relocation, ventura:        "fd8b8878bd36624fda494d22f31acb7d56cd13a90248463123e0e055746757be"
    sha256 cellar: :any_skip_relocation, monterey:       "948b50f3eababc577719b90b909f9a4a0278b603a25b8b42e9c527d24ab131b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e64ed7b5e25678946da8105760a50b4321a184be09837ae165e86f7d5088c5"
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