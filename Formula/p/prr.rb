class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https:github.comdanobiprr"
  license "GPL-2.0-only"
  revision 3
  head "https:github.comdanobiprr.git", branch: "master"

  stable do
    url "https:github.comdanobiprrarchiverefstagsv0.19.0.tar.gz"
    sha256 "76d101fefe42456d0c18a64e6f57b9d3a84baaecaf1e3a5e94b93657a6773c11"

    # support libgit2 1.8, upstream pr ref, https:github.comdanobiprrpull67
    patch do
      url "https:github.comdanobiprrcommitc860f3d29c3607b10885e6526bea4cfd242815b5.patch?full_index=1"
      sha256 "208bbbdf4358f98c01b567146d0da2d1717caa53e4d2e5ea55ae29f5adaaaae2"
    end
    # support libgit2 1.9, upstream pr ref, https:github.comdanobiprrpull69
    patch do
      url "https:github.comdanobiprrcommit84c0d0c324fb5a1334b72dc1fdf65c8e81c2cd01.patch?full_index=1"
      sha256 "e695229e73e83f5d06c9b9ac9714c053088f6862d6db699e1d3101413b2d06d4"
    end

    # completion and manpage support, upstream pr ref, https:github.comdanobiprrpull68
    patch do
      url "https:github.comdanobiprrcommit8ba7fdc2fcca86236311c65481af5b27a276a806.patch?full_index=1"
      sha256 "f74882907e25bc1af3e1556407c84e5477b3d7be3e51a2b40178ae17aaafaa0d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1935f2644eed1aea55ec06e5169cf4768f4add80d324be5bb986ba6e6b4cf416"
    sha256 cellar: :any,                 arm64_sonoma:  "5eb5d8287cde7049ce2ffc0dac1e5bb46a8d8d112f69cefac3fd2b0af95ba0cc"
    sha256 cellar: :any,                 arm64_ventura: "a6ca2fcec336fe4248924d153b101e878575a5f64156be4ef656d9ee25e79c0d"
    sha256 cellar: :any,                 sonoma:        "ae3767c62caefd53b2eac176b08cf87e3ea21396eb75861b710e4d328d7a19da"
    sha256 cellar: :any,                 ventura:       "9312b31f0f636a53a15ac44e63495421d6c94836bd13e346914cce9da3a6845f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e577e866ec76b2a49589a6d10cbdaad14cbce93fefa69eb899fae6fb9e6424"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Specify GEN_DIR for shell completions and manpage generation
    ENV["GEN_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsprr.bash" => "prr"
    fish_completion.install "completionsprr.fish"
    zsh_completion.install "completions_prr"
    man1.install Dir["man*.1"]
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}prr get Homebrewhomebrew-core6 2>&1", 1)

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end