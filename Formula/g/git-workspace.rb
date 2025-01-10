class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https:github.comorfgit-workspace"
  url "https:github.comorfgit-workspacearchiverefstagsv1.8.0.tar.gz"
  sha256 "b6499b70362730dbe1674fd07bd9aefef0bcd45ba4504ed0cce62ef2c7ecad1f"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37536ae9e70e4244174267114d5727b34d002276e3daaf09ab03eea059288915"
    sha256 cellar: :any,                 arm64_sonoma:  "bd263f8dcf6df3bc14102c2300a2735c07e3ca4d03e89d6b461c1266f64bc993"
    sha256 cellar: :any,                 arm64_ventura: "5063d18c73c5f99151cfb9c7bf9f057e401264104c2106198bdaf9d4ae1e1dad"
    sha256 cellar: :any,                 sonoma:        "6a6a2b672032b44124896ae6d4817e9a8b4e86a69fa8fedc7eb15f28832cf4ed"
    sha256 cellar: :any,                 ventura:       "5223e5ff55ff03b1aa3e6ba8621da0351156424bc6cb6657b0ffbed528a6414d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4cd16d0a2c3941d7abc2fd59a437ff96fd62b4f6dd552d52f1a8af4b8286c32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  # patch to support libgit2 1.9, upstream pr ref, https:github.comorfgit-workspacepull390
  patch do
    url "https:github.comorfgit-workspacecommit9250483b38f24ac60a025ddcd49b21f847d37b60.patch?full_index=1"
    sha256 "3d8201522021b5aacfb9b332c02ddac4c1ca409857cbe4acca226f229fd5ae8f"
  end

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

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end