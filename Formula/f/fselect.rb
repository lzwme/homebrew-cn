class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https:github.comjhspeterssonfselect"
  url "https:github.comjhspeterssonfselectarchiverefstags0.8.10.tar.gz"
  sha256 "8dc69266a7dc2b9029b111053ec761388fecb1473f68d0f2241a33cfc2bb296c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6662c72f2b2733202dc4c9011ee5d7eaa5e4146237e8fc7cab5532186009ea09"
    sha256 cellar: :any,                 arm64_sonoma:  "24c188bd49927478caa688e4ea073982cd293a4a8d59a6f0f4905a393968562e"
    sha256 cellar: :any,                 arm64_ventura: "2682b67ecc4b1e8e4538d8b0bd31f2366b8bae94f0437ec490b7a19c98ecae40"
    sha256 cellar: :any,                 sonoma:        "231220fc27238b4907c2a10f6b54ed88e17ea90fbef02155afb63df4db65ab2d"
    sha256 cellar: :any,                 ventura:       "c0f9db29c0a746141e6d277177ca34ef4fe76356f1f90f901161d64632be0ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c23eede3272e9b289fd34eb55fa3f644202738b7d08713906df4f39bf7bbfc8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50b366606b5f2fa65586fb2d6c29c38c91d894fd50d910c75c84135fcc3d891c"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utilslinkage"

    touch testpath"test.txt"
    cmd = "#{bin}fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end