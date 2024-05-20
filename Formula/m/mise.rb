class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.18.tar.gz"
  sha256 "d7c052e4c80e0a6b081ad9974f72496e2aeb717a1f43d4442904a6d80cd87ed6"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b9f974468397934f5de3e1d64222197c21d63ba65f27c0a3169db72bbd550d6"
    sha256 cellar: :any,                 arm64_ventura:  "e6794d729c97d4cd978a54363dc4610056ed7c1b253f685c2520116dc983900d"
    sha256 cellar: :any,                 arm64_monterey: "9b98cbcc22297f4eefc105860f5372d27eb0e8b99785acd3bbebf207f6319e97"
    sha256 cellar: :any,                 sonoma:         "13833bb16cd49a34fe5edea1130ba7f035effa551cc28c11813e434e49bdb8aa"
    sha256 cellar: :any,                 ventura:        "b499acafe93afa807119dd3ccb14871a99f7844c6b7222541d938ba90afbe395"
    sha256 cellar: :any,                 monterey:       "1c4c79db1e64f1d133bf1880ad471e522571127812eb508ccc5d053b9a0c5983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1e84ab7d3ec5ffa76f96505ac7c5dd6ff8274ffcbc2cd20a0607883ff1ec47"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "#{bin}mise", "install", "nodejs@22.1.0"
    assert_match "v22.1.0", shell_output("#{bin}mise exec nodejs@22.1.0 -- node -v")

    [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end