class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https:sheldon.cli.rs"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2
  head "https:github.comrossmacarthursheldon.git", branch: "trunk"

  stable do
    url "https:github.comrossmacarthursheldonarchiverefstags0.8.0.tar.gz"
    sha256 "71c6c27b30d1555e11d253756a4fce515600221ec6de6c06f9afb3db8122e5b5"

    # libgit2 1.9 patch, upstream pr ref, https:github.comrossmacarthursheldonpull192
    patch do
      url "https:github.comrossmacarthursheldoncommit7a195493252ca908b88b5ddd82dd0fe5ce4ab811.patch?full_index=1"
      sha256 "45432a98ab2e8dbd772e083a826e883ee0a2de3958bda2ea518b31fab91cd9f0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "875da89f7f77f5732a41cf11d9e07b910c83df53308e15db903cd8a94db399d2"
    sha256 cellar: :any,                 arm64_sonoma:  "184896fd71f1b89f52b938b00b11a3a970b6686f169a4901de096eb62b6394e6"
    sha256 cellar: :any,                 arm64_ventura: "3c2e0757902ea633afc098891c7d0dffc180ac777d204914010bf0a90e979e9b"
    sha256 cellar: :any,                 sonoma:        "99d2d886fe8e349ec5fb9e94fabdf4c0d745ac691ff9523e0ab5aa38abf49141"
    sha256 cellar: :any,                 ventura:       "364a7a195e5bdabaf3b3a4f792e3d7cd81fc7179b10a8398c71c51e814963d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0926421d405a3141ab5fefc7370874c51705d728900bfc25a5f3e105f846b2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
  # FIXME: We should be able to use macOS curl on Ventura, but `curl-config` is broken.
  uses_from_macos "curl", since: :sonoma

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https:docs.rsopenssllatestopenssl#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Replace vendored `libgit2` with our formula
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "completionssheldon.bash" => "sheldon"
    zsh_completion.install "completionssheldon.zsh" => "_sheldon"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    touch testpath"plugins.toml"
    system bin"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_path_exists testpath"plugins.lock"

    libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    libraries << (Formula["curl"].opt_libshared_library("libcurl")) if OS.linux?

    libraries.each do |library|
      assert check_binary_linkage(bin"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end