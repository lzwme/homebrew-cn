class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https:sheldon.cli.rs"
  url "https:github.comrossmacarthursheldonarchiverefstags0.8.0.tar.gz"
  sha256 "71c6c27b30d1555e11d253756a4fce515600221ec6de6c06f9afb3db8122e5b5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrossmacarthursheldon.git", branch: "trunk"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7721bb7c252d11827db27bc2e94599b59e2d5189f13da21c0baf2985e2a0a006"
    sha256 cellar: :any,                 arm64_sonoma:  "fd934fd9477dd230780e8c18386a4255598278ae6a496abef5a262ddf7599ded"
    sha256 cellar: :any,                 arm64_ventura: "e5a9fc87b96346dd783949200364782fe94899c86791b2005cc939616ae47767"
    sha256 cellar: :any,                 sonoma:        "7eac3be77a7a3d35685ecefecea705e3b2c506b81e4c649bfc8c510f68f7b585"
    sha256 cellar: :any,                 ventura:       "9c4d728a1e1541f33ff20906cdacc5fd055ee5567dbbaf36b00c274c594e8601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c15f35368003e34e91eaa5e4f78edccaffbde9ce2c1a3109eeebbdb15ea4c4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
  uses_from_macos "curl" => :build, since: :sonoma
  uses_from_macos "curl"

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