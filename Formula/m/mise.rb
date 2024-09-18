class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.9.5.tar.gz"
  sha256 "fef5148de32be77b7e479d90f4af5a2d19c150e4ad866a81284c0df0edddb653"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4b29bff8be8f7ec31a2f7b80dcc9a709c4ed02efff33b8c15e298e4c0a58579"
    sha256 cellar: :any,                 arm64_sonoma:  "f0ea5388d94b4d64ebce45e6a94123781f4a89c037df180993cc33243548a3a2"
    sha256 cellar: :any,                 arm64_ventura: "19f2697b9bf9841e146b7f84fc5c10b4a2011fff388f6c8490ca556d548e6df2"
    sha256 cellar: :any,                 sonoma:        "ea4181f6694f2616a3143e6b0d3b2968f74d3ae530fb75c1b1e9159b73f4fcd1"
    sha256 cellar: :any,                 ventura:       "02271fae0fa6c8d6b0a10c7b8ac7cdcd2aa86bb41a130e15d7ac42a6b38e4a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca024d45ad6487eb58aea4430773a7b798c7c2cfea2cf2cacd7348b154294bf"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

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
    system bin"mise", "install", "terraform@1.5.7"
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