class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://ghproxy.com/https://github.com/orf/git-workspace/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b9dcc7ad2c88f63a12af4caafee05b433391a6607252330335d37676686b24f3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4916e5b9e140e8aeb2a9a64d7cca8c52ca06874def20ad5a9102f9da0452692"
    sha256 cellar: :any,                 arm64_monterey: "ea678e42dbf3219e6ce8f4ac63efa60395d98687ea63a110c2d7d18bd77c4523"
    sha256 cellar: :any,                 arm64_big_sur:  "8f20667732dd785d5351c7ff3b57a6135016f859e35b905223ba734f1248c5c9"
    sha256 cellar: :any,                 ventura:        "65d327ce21f699882553e2bebe0e212a92ea9fda20dd59efed63a4c764ab293f"
    sha256 cellar: :any,                 monterey:       "10de2f2e50332fcf6ba52ca55d1305a0090788819b5845e3386208bb5b263001"
    sha256 cellar: :any,                 big_sur:        "689f88d6e2773f27f42d0b46245a9b14e0450ab7ccf093d48a8339209913df73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d10db5bf3a4ecef3a7e1fac699b0d7f1a8b0c7eaa5659c2cb72ecf720dea69"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system "#{bin}/git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output

    linkage_with_libgit2 = (bin/"git-workspace").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end