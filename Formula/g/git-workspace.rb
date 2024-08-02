class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https:github.comorfgit-workspace"
  url "https:github.comorfgit-workspacearchiverefstagsv1.4.0.tar.gz"
  sha256 "fb66b03f4068950ba2fac73b445a964b2b941137f9b31f5db9f4fba1a73d3d4d"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3687a7078673bec581e010035dff68102c1b9b99483603c186293b76435c9b67"
    sha256 cellar: :any,                 arm64_ventura:  "e85ea0736d8f5d773c493919ef07c29546d24711bdb97bac501cbdf11afd00aa"
    sha256 cellar: :any,                 arm64_monterey: "53450fe5c00e6ecfee12d92325b6e2024ef4d03f0cef5a585f8ca2838a9a6e5c"
    sha256 cellar: :any,                 sonoma:         "1d9e9b3fe351fd75c43b4dd8b39b8cb852b19d13880fb23836554e568e433f94"
    sha256 cellar: :any,                 ventura:        "e650a4387afe3dccf972b9f0e6d28e7615eb8f7ddcc2d47b1f322aa2ba449b58"
    sha256 cellar: :any,                 monterey:       "fd39b3eff416154c10b38860e687f5e58260b3ef39dcdd64e64572f545100e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a18e7dac33b65e6fc4b430cb2e6f87e2df7ded08f59f7b2612c1828d756e5d2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system bin"git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github userorg foo", output

    linkage_with_libgit2 = (bin"git-workspace").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end