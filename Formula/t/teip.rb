class Teip < Formula
  desc 'Masking tape to help commands "do one thing well"'
  homepage "https:github.comgreymdteip"
  url "https:github.comgreymdteiparchiverefstagsv2.3.1.tar.gz"
  sha256 "29147678f3828a3ed83c0462ec8b300307cbe8833ce94ed46016a5bfa3f9b3a5"
  license "MIT"
  head "https:github.comgreymdteip.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96ca6b04fc906c04cc05a0cc8a5beedc3a277a296403eb0d4d9f73a5bac30937"
    sha256 cellar: :any,                 arm64_ventura:  "cb341c1fc5e81ed1ed1f1002d12317f3acc1d5758bcb357759842b25956a02e6"
    sha256 cellar: :any,                 arm64_monterey: "4c76498ece6924e88c723d5c2977b9c0dcba7b297b49370983f4b0ca24d42037"
    sha256 cellar: :any,                 sonoma:         "1a5b47217756090ea94f8b355d1f6df605c474c24ef5d039ea3768f37a065055"
    sha256 cellar: :any,                 ventura:        "52b3135da21a531d14d1253fba9b877abc20a7c08dae9441c0b12950f61f3375"
    sha256 cellar: :any,                 monterey:       "f2b205f63cbbc61b99ccc5807e26dd3c0c23c41b540468400b93db8687a540e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2dae639a3ca2ac77b99afea4a2783ac4fd409a2a8cc95a7746cd7e69ef779a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "oniguruma", *std_cargo_args
    man1.install "manteip.1"
    zsh_completion.install "completionzsh_teip"
    fish_completion.install "completionfishteip.fish"
    bash_completion.install "completionbashteip"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    ENV["TEIP_HIGHLIGHT"] = "<{}>"
    assert_match "<1>23", pipe_output("#{bin}teip -c 1", "123", 0)

    [
      Formula["oniguruma"].opt_libshared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin"teip", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end