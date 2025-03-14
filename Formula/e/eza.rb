class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.24.tar.gz"
  sha256 "e5a1761f05adc74b80d59036819e768060971c6f5107e208024c752a2af02ccc"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e248f0e63fa45414caae6d77000a414b417b68efbcd1c33bda1d4ec975991b0b"
    sha256 cellar: :any,                 arm64_sonoma:  "8b567a3fa6935fba2d76b1993657ea750111849d9e8cd94cb6dd51dadb65fc4d"
    sha256 cellar: :any,                 arm64_ventura: "4ca774438b9acdc14057ad308d23353989dc124e7a12e32cb49bf0db6fcd7e8d"
    sha256 cellar: :any,                 sonoma:        "1eef39e94125cf2156b07aad5313b66790de35a9a0425153a23692a8aaf62301"
    sha256 cellar: :any,                 ventura:       "8748910465b1d0d79e00351c6cae24d97faa8a476bf2e15f8f96e8994db916b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "255b4bee6290ee25b18fbcef491e1dd9157e4d376161b65621423c591e225347"
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