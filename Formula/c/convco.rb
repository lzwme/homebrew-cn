class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https:convco.github.io"
  url "https:github.comconvcoconvcoarchiverefstagsv0.5.1.tar.gz"
  sha256 "1d1d275253567069b49d66abe65c04ae1fd5a5d3b8c173f57d7e1f696794c311"
  license "MIT"
  revision 1
  head "https:github.comconvcoconvco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61fb9360e5d3ec10142eb7142f77994cc15d2451f4beb7db671a69b281930d46"
    sha256 cellar: :any,                 arm64_ventura:  "857d2354c07e7153b4be0241a2a1cf72e3601baa7bbebc49c3900805d0b024a8"
    sha256 cellar: :any,                 arm64_monterey: "38405fbb5a10f4c6b0f36cb3905332440a2eb17f14ed721cb94e4fa9763326f8"
    sha256 cellar: :any,                 sonoma:         "7789bf3b472a00b9f0867939eee940fd49684d1b96179f531749f645909f8812"
    sha256 cellar: :any,                 ventura:        "396f514fa6feb31c81a11120a6a0413e92a4749252f4ed5b067077a8a33df17e"
    sha256 cellar: :any,                 monterey:       "633f5ca9ad08fd017836f916969c921d153d0602c00d43ff9b0d7ca26dc98a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8bd724cb142766e92819c19bb4aaf83dc4e9f4c303f54306de3cb257d9c5717"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "targetcompletionsconvco.bash" => "convco"
    zsh_completion.install  "targetcompletions_convco" => "_convco"
    fish_completion.install "targetcompletionsconvco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n,
      shell_output("#{bin}convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_libshared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end