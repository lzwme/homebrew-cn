class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https:github.comorhungit-cliff"
  url "https:github.comorhungit-cliffarchiverefstagsv1.4.0.tar.gz"
  sha256 "8ec9a2c9cd0e97a8111a82bcf2fce415f40818897bdc76a2c5cc63d99114ec30"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7763105faf1d1e8c135a5270ee3785f4ced1285cbd03174dfe2f6485ee7b61f4"
    sha256 cellar: :any,                 arm64_ventura:  "e20b7dbc635f860a3e8f02b5d76bb1915b964791876e426358c28a30f56d0a1a"
    sha256 cellar: :any,                 arm64_monterey: "150ebcb6afbc4f77db10e58df1f21a1cc378c2640581d01ff6b73504324f575d"
    sha256 cellar: :any,                 sonoma:         "76fe09d233cca43759946fecc1fda079cc62e540ef670a1997d3c6e7df9e6256"
    sha256 cellar: :any,                 ventura:        "258e5f7e4cbdc91dba2b7177ce5f2b532eced6378ee16a5fe40743233a1901dc"
    sha256 cellar: :any,                 monterey:       "845954b8c8191a10c4892afef729f6681c675410736e858d90feb9f0b3cc57aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bf03df8f277405c695c632bbc2745cac390d7ca8923c6c5bcb19fe71533002d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")

    linkage_with_libgit2 = (bin"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end