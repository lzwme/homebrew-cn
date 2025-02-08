class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.20.tar.gz"
  sha256 "8731184ff1b1d3dbd6bb8fda8f750780a58ccac682fd6344d92160dc518937de"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c265042261631ff183091d2bddb1f5dfe531234102c97dabe54ed1db4d406676"
    sha256 cellar: :any,                 arm64_sonoma:  "477e5db14d07eebc62bf2a620d563847bcc056dc2d19d65a0bdb0a0fc07febe0"
    sha256 cellar: :any,                 arm64_ventura: "5191b35e5fd3e8e29471020e23b325348b684929b9d5c1e987b2616a2360aef7"
    sha256 cellar: :any,                 sonoma:        "da86a412521993adc3039959ecbcb9dac0a35ba7757a008f9f3427147b47184c"
    sha256 cellar: :any,                 ventura:       "4ea507c36b1b2d01c08c11b9254021c7b99472122877ec05eb3598d0928eda38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f160f5c0b1ec00ff9b58458d1475e21770c40fc4c2bb93e80225f6a11993f12"
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