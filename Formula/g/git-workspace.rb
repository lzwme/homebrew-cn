class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https:github.comorfgit-workspace"
  url "https:github.comorfgit-workspacearchiverefstagsv1.8.0.tar.gz"
  sha256 "b6499b70362730dbe1674fd07bd9aefef0bcd45ba4504ed0cce62ef2c7ecad1f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e3014c3ae6e598214600ff258e9feff56f15c8e7c9adca97531b3b0da45f741"
    sha256 cellar: :any,                 arm64_sonoma:  "5fd7c6693cd59d753d788b3b0f4db497fe9a881f985177301207b1fc71c0b71a"
    sha256 cellar: :any,                 arm64_ventura: "91dcb531a3afab0d3f095eee50f31952c533c1805f0546311b85445da48163bf"
    sha256 cellar: :any,                 sonoma:        "5539681a422dd24fabd97d4bde87a260db8c36db20ded02801d26e3c2f9241e8"
    sha256 cellar: :any,                 ventura:       "bb9928d297f3534b54774f21ef1114326af4e9743ad7a4e26b1b5dc80337354c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28872e2b1ca35ed93e46dad8f7cce54dbc0941073151c00a67040c2bbb59d6c0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
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

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end