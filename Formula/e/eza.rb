class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.20.5.tar.gz"
  sha256 "3455907abddd72ab405613588f82e2b5f6771facf215e5bcd92bca1a82520819"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15efd8355d49e97521a03a881b3dd3874bdfe09cc3c18e090d76959138087320"
    sha256 cellar: :any,                 arm64_sonoma:  "a966f4de04e0f1aa92dc59b530819e629e6680ff0d57528eb8e7a0594dbf4eb3"
    sha256 cellar: :any,                 arm64_ventura: "9b26bb7e02179898430d1cd8a9117c906979ce2b681095ae0bb5ab71a646eac1"
    sha256 cellar: :any,                 sonoma:        "fc15164a63fb9fd6dabe0dda6b2766ed1aed4a3a5c706149109fe0aedd884815"
    sha256 cellar: :any,                 ventura:       "6b400cab876387d88fb9056f898337d24135b70c9d255bc13725218da32bbd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a4c9f440ef836bb384d87531a5132e76489182780afe5840190cfbe7629cd0"
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