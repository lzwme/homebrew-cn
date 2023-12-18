class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https:github.comlgarronfolderify"
  url "https:github.comlgarronfolderifyarchiverefstagsv3.0.13.tar.gz"
  sha256 "9b72cac5aafb3bf39583b0427fd8bb3346a5a891def6500b5118c7227431dcc0"
  license "MIT"
  head "https:github.comlgarronfolderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "006734a8e92be9a5f973e32a9ff3d635d487cdeb576ca926bad8e5f0ca4ece40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c7504ded509e8704562609e37ed3cae171d68ae2d817d6582cb80c2a16313c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf6a3acaa3b6b5775448664684068c508666ff616b3a56e235807acffe991cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "33245e0ac70b0c38c672c10233e63a7884fd2cffa8768a4bc008fd97201c2705"
    sha256 cellar: :any_skip_relocation, ventura:        "00e476f39e0e0ff3116dc94980a11e6f0443fd7914238f5d6f584212e3590fc3"
    sha256 cellar: :any_skip_relocation, monterey:       "c72db1ccf5fdaa63ef5b18d47db46e3aacdb943d91a9428754d92463dd070532"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http:www.w3.org2000svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" ><svg>')

    # folderify applies the test icon to a folder
    system bin"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath  "Icon\r", :exist?
  end
end