class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.6.tar.gz"
  sha256 "bf7c30789be7866a36fda9d2b1bb351f41675f4c8bb8c89e7ff85619cc894bfa"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5515966252d29a1ea7c9109299fbedb9167ecff8e5221e9caf6fefd24b2a1ca7"
    sha256 cellar: :any,                 arm64_sonoma:  "95403c38c4f46ce32ef785e826478f47ae548a5999c575ee7a6bac6ded09ad67"
    sha256 cellar: :any,                 arm64_ventura: "0699782e4d15ce173695d1277c537a0d47f54459ac189342431fa72c73559f81"
    sha256 cellar: :any,                 sonoma:        "2022a4e19cdfa6f30a7ea29026707e5b1322f2b9bca3679736e5524a3eabf6f2"
    sha256 cellar: :any,                 ventura:       "63bfca0d718dad0cff2f8eba95f67d21e980ef34212db0d19e31312ac76d90db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d190ea3226e55285f4ab2e683cc191541a4726bce12bf91b086d2fd6c0239b16"
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