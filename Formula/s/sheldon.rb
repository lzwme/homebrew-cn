class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https:sheldon.cli.rs"
  url "https:github.comrossmacarthursheldonarchiverefstags0.8.3.tar.gz"
  sha256 "fea159b473a9ae48779ae2094eb909262361f45d2bf3a2e3968eddacb8e3b992"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrossmacarthursheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a434012f0248b23221448830af4681b7d514b3f91cb69d7885655947c3799c66"
    sha256 cellar: :any,                 arm64_sonoma:  "83c1a9a601c18324db6c1756fddd36b5a0798faf4fe606dc05eaa709a43949cc"
    sha256 cellar: :any,                 arm64_ventura: "c717096ce84dcda848951b2794d2e8cffa076ba36ccc5807b664164985b996d4"
    sha256 cellar: :any,                 sonoma:        "e76795e4517ead55667041790c77da13e10d0e6d0dc7fdb26c221659a137128d"
    sha256 cellar: :any,                 ventura:       "f9de253bc3237de0c0828c892576ccce62fe623c2f65e6306ecd60e7f04b754b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604aae5c215f19d00dea496fb3024484ac641b5b82d910764d35d8abcb33cd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1847ee940a3b575d225e592a3fca12525c42c96785ba3b8db5b3dcaca057e09"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
  # FIXME: We should be able to use macOS curl on Ventura, but `curl-config` is broken.
  uses_from_macos "curl", since: :sonoma

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "completionssheldon.bash" => "sheldon"
    zsh_completion.install "completionssheldon.zsh" => "_sheldon"
  end

  test do
    require "utilslinkage"

    touch testpath"plugins.toml"
    system bin"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_path_exists testpath"plugins.lock"

    libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    libraries << (Formula["curl"].opt_libshared_library("libcurl")) if OS.linux?

    libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end