class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://ghproxy.com/https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.11.tar.gz"
  sha256 "36c3b2c7bcd1d9db5d1dedd02d6b0ac58faaeb6fd50df7ff01f5cf87e5367b52"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e75585e468d2472001eccfd61112493fd71e55ee1b0f577f5a452f1705258a1"
    sha256 cellar: :any,                 arm64_ventura:  "33b9a51cd6072917ebb00fd27cac1216e099561f8a48909341895723c7a52c59"
    sha256 cellar: :any,                 arm64_monterey: "194c2d56bbd9d008f6737a18128c6f0162c1a5257e93c5b6df29f2bb2faaf803"
    sha256 cellar: :any,                 sonoma:         "0dce2df549cd2573c0d5f7e7c2f2e50f8bcaba9212e3925a494aa8fb797b0436"
    sha256 cellar: :any,                 ventura:        "a6b9eb868bc0b9921b87939d6cd71017529a4f05657b9d58b53e6b87f75395ef"
    sha256 cellar: :any,                 monterey:       "d83b05c3798f6d46f7b5553e26983c2a0b5f7fffb428854043abe84021a1ef70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b8a7a652a3312ce0723edb543a0b770e8bce4da0d999ecb8b8c2058ea62c70"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
    man1.install "Documentation/git-absorb.1"

    generate_completions_from_executable(bin/"git-absorb", "--gen-completions")
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"

    linkage_with_libgit2 = (bin/"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end