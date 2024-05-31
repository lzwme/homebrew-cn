class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.26.tar.gz"
  sha256 "9766b5a452bc3595233f18e72cf3cfd43589e5dc787f23f575d4830f2d174499"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfdd6047179f57d1fe170547d46cc2dcf366311786dd0b31f806fbb76245edbf"
    sha256 cellar: :any,                 arm64_ventura:  "529f786d9eb5a3b035c33a4cd3723306e4722a82b76285043d5af237753b7a36"
    sha256 cellar: :any,                 arm64_monterey: "c2e212d15d0b0b243854938fd4db674c6a8048de8e92defbb1d67f6c20e6997c"
    sha256 cellar: :any,                 sonoma:         "8f0f2c681759778b5e4dbaa7e039e00a5eaf91fe00aaa2906444f784d1916d0a"
    sha256 cellar: :any,                 ventura:        "5efa97da0869f87d69cc0b9e2b7daf0d748148d8a923fad9bcb0e4ce1ca11829"
    sha256 cellar: :any,                 monterey:       "31527e7135c71a504a38a59486415765dd523b234ee4bfcec99ee0acdf5003af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98f547a4ee5a51440c3e2fada090d539a04c253a61727d37f742232967b6487"
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
    system "#{bin}mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}mise exec terraform@1.5.7 -- terraform -v")

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