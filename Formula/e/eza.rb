class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.9.tar.gz"
  sha256 "3f55cab4625bbd0af01bd4049330217b392fe915b0e5764f4131c9118d4f92d7"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e06dc431bc08d19d9532359f98c6654b98f2a7f192039d38f9fba007002288b3"
    sha256 cellar: :any,                 arm64_sonoma:  "50931dc0cecbea0a4b03bea1250893714f81e8b06671b974bccf853735a7cbf8"
    sha256 cellar: :any,                 arm64_ventura: "25bb1034fffbd3b96dd7af63c290839188c3c4258d4d5cbdaca6273278166221"
    sha256 cellar: :any,                 sonoma:        "7eac9f188bb0b7d0a63df4608b11edf4e3037855847f1c690b094e205da76448"
    sha256 cellar: :any,                 ventura:       "eb6494e07d1cdc4da2cedfed599cb3509453adc5037f835a3bd2e10ec3b8d381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "420a6157fb57f8dad5ad615eefb7e2eefeb1e2f87be09ec204d29b36288fecb2"
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