class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https:github.comsharkdpbat"
  url "https:github.comsharkdpbatarchiverefstagsv0.25.0.tar.gz"
  sha256 "4433403785ebb61d1e5d4940a8196d020019ce11a6f7d4553ea1d324331d8924"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsharkdpbat.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f6511940674c9e8097336d21780e84bfd49d93e56661ec93ed26178af9938f3"
    sha256 cellar: :any,                 arm64_sonoma:  "97e7b211e43959541347fd569fef9364389aed0545ca77645c6f5ff6fe01ab7a"
    sha256 cellar: :any,                 arm64_ventura: "76e2e716127aa97fd1682c8ac0109cd77e9562026d6c74cc28ff7b24c811fdba"
    sha256 cellar: :any,                 sonoma:        "f0552ad124c44df31867880665faed7e06a03c7184f6d98ffe5de5aeebd0634c"
    sha256 cellar: :any,                 ventura:       "7ca686529ebe102c76b3b1b57e0562ece796bda2ea3e4c00aa2b550c08eafc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56cfb323e50c0b946af214ca8fd9733d94149c6ca402d8d1a47b5731e915683b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "oniguruma"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["targetreleasebuildbat-*outassets"].first
    man1.install "#{assets_dir}manualbat.1"
    bash_completion.install "#{assets_dir}completionsbat.bash" => "bat"
    fish_completion.install "#{assets_dir}completionsbat.fish"
    zsh_completion.install "#{assets_dir}completionsbat.zsh" => "_bat"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    [
      Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
      Formula["oniguruma"].opt_libshared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end