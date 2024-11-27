class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https:github.comorfgit-workspace"
  url "https:github.comorfgit-workspacearchiverefstagsv1.8.0.tar.gz"
  sha256 "b6499b70362730dbe1674fd07bd9aefef0bcd45ba4504ed0cce62ef2c7ecad1f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a4fe8611f58904c04941f7d24f0c05690e94a530e1a5c6a65e1b66ea17a63c7"
    sha256 cellar: :any,                 arm64_sonoma:  "4cbcd08c8721d9d57b484e83370207dd7d624625b3fe3fe2f3b3a032ef57e602"
    sha256 cellar: :any,                 arm64_ventura: "2238606be70e0cda69f2b1385151a603da2b4cb09d5d5596801bd297e78d809e"
    sha256 cellar: :any,                 sonoma:        "24d8208eaa671dc162bad95db12f51ed4a33e8ba47f0f5d734e292d97d43f1c1"
    sha256 cellar: :any,                 ventura:       "09b7800f722e02bbee6a0d894b06a88ebd8a7b1606532c7c922b285b5dab0dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac36464fd5fef9aa5c473173281b4a73ded57c21a6fc8595742a1b6a6a539e7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
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

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end