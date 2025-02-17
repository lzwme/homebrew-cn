class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https:github.comhouseabsoluteubi"
  url "https:github.comhouseabsoluteubiarchiverefstagsv0.5.0.tar.gz"
  sha256 "e10f84c3bc83effd990d11d8821d9b5bc08b3dce52a526e850d89f1055dd44bb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhouseabsoluteubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f7a6894c9cd5bc5d00f565392285a7c0d799667fab56ebd025bac19180ff54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13336bea70e7a0e22be84dcea87f9bb1cc41230a975b15f3968151c4e92c27c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2be906dee4c761ec366bed51feffe7d69ff4db2a7585e60dee7bb96e529732e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea1d13e82ba89a999a1affe32d2b45ccb6ddbb6f6ff0e8cdd97b6f97f3d0f22e"
    sha256 cellar: :any_skip_relocation, ventura:       "b2f72dc9a8677fdd230cd0daeaba1854f43d5cede09d82dd96e8e1c8809b4e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eb092b49663d748fcdba2266a60c9762d3fb32bf016f91ec2c5803445fb6ff5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ubi --version")

    system bin"ubi", "--project", "houseabsoluteprecious"
    system testpath"binprecious", "--version"
  end
end