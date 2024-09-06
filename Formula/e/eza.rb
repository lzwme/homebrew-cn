class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https:github.comeza-communityeza"
  url "https:github.comeza-communityezaarchiverefstagsv0.19.2.tar.gz"
  sha256 "db4897ef7f58d0802620180e0b13bb35563e03c9de66624206b35dcad21007f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fe7fac47c2d7958d6c16f9f46186e4fb4d89a6e53609681d2a6b0cd90c313ca"
    sha256 cellar: :any,                 arm64_ventura:  "f4d9927ad5c836436d7a05e64678554671aaade533ea9c3e297321f6339c69c8"
    sha256 cellar: :any,                 arm64_monterey: "dc965e318a6c8e871b6e13cf1d2dc09573ac2b5f2983e6bd891933ab0f221768"
    sha256 cellar: :any,                 sonoma:         "229cc09bc9ed28c3c567787046836508ae8b6b2eaf8cf0f000289b5c3ec81902"
    sha256 cellar: :any,                 ventura:        "555b6242f481d828e2f7778afa1b03886fbc93132c1ca78ff41f562a4a115f47"
    sha256 cellar: :any,                 monterey:       "dbebc74913633b46fd1071276ac21041e20f6e0641f31a17ab15efe6a8db29b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d4bf6c6a4accda011014be3ddddedc89d0040e0c64c47acc3a33341dae311c2"
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