class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.23.tar.gz"
  sha256 "dc844461901a948b26a9beb1e676353a9f8742244ab59b09e74fa56964b09dfe"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50d20b9de386e179512a6c0a342412fb69de46e63056cadf9a8eb39bc83b346e"
    sha256 cellar: :any,                 arm64_sonoma:  "d2eccb4f950323137dd06a3d1026690884186b853f90839ca7af476b83480f85"
    sha256 cellar: :any,                 arm64_ventura: "2bf222ef56a40d86ceefa0c1c37ed65da06d20b3206620c7c8f81f325c8b51d8"
    sha256 cellar: :any,                 sonoma:        "a512f39048badba155fc71c32d75f213fd77cad914be52248d8ce7c9ca6cc297"
    sha256 cellar: :any,                 ventura:       "b630956b0563ce98871b497cc0333c55ad1b93aedf4e274007d6167205789700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32ee43dc93fdf3a69fcaaecd33392071514ac3cc14eb3a546e3f16d0f8b6c97"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsbasheza"
    fish_completion.install "completionsfisheza.fish"
    zsh_completion.install  "completionszsh_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "maneza.1.md", "-o", "eza.1"
    system "pandoc", *args, "maneza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "maneza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}eza #{flags}").lines.grep(#{testfile}).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end