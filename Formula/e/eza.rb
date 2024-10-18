class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.3.tar.gz"
  sha256 "51a61bba14d1e4043981cabc5cf3d14352bf6a4ca0e308f437d0c8d00f42c2f7"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4afb1f40157d036bdf51445e401670e4d9330b03dd9cedcf6bc492bab00f969c"
    sha256 cellar: :any,                 arm64_sonoma:  "13b30abbfd52bc9378d5cb9707ae876901e5ba46422b654a57bac0c916b4096d"
    sha256 cellar: :any,                 arm64_ventura: "a6a922fdf0911623008c804708feddb48b821b6c6e775cce9f0ceefa314d82d9"
    sha256 cellar: :any,                 sonoma:        "6a1cfa3cdaaba6b60bd9ff8f44bbb1075bae2e047139928f94b6c7a85ab52769"
    sha256 cellar: :any,                 ventura:       "372a3be03f1c89ed62f5b0779de956f8f36a7c883f9566fde78d4e394b22b29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3beba4a7ea8ebd3cd9a3556248505f90f5c1609149d761c45c14c2e1706e27ce"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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