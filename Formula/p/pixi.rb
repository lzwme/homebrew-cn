class Pixi < Formula
  desc "Package management made easy"
  homepage "https:pixi.sh"
  url "https:github.comprefix-devpixiarchiverefstagsv0.18.0.tar.gz"
  sha256 "d5626ab3dcaaef741b97ce57268cd5d7fab74fba73ab31ac21d32dada60e8025"
  license "BSD-3-Clause"
  head "https:github.comprefix-devpixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a732dfef741e2cf01db38857609fd85112384f684631f28e57c345626a03aa50"
    sha256 cellar: :any,                 arm64_ventura:  "988b82afab81e817286082c0bcea7dacf36c8bd465f956532bcfa7652df466d3"
    sha256 cellar: :any,                 arm64_monterey: "4efb9ecfba747dcaad65dd34ce81053ca955fff6db570d6f2b9e78468e042caf"
    sha256 cellar: :any,                 sonoma:         "abeaf416844ec2349b344aff7dcb5601946f933887f5f308bcfc152bca1ac82a"
    sha256 cellar: :any,                 ventura:        "bb177f5f87aead43ed7825af2b288988ecacd064bbe45662f55d3ae5ac7d478f"
    sha256 cellar: :any,                 monterey:       "37ac2b54d5b9ad43541d5d6a7b42a92166cd441cd343631fe53d45f85d5e6c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0672a4c0c48681cc324b90403c93d0be985abebe9e732ac41d22d69163f3c989"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"pixi", "completion", "-s")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}pixi --version").strip

    system bin"pixi", "init"
    assert_path_exists testpath"pixi.toml"

    linked_libraries = [
      Formula["libgit2"].opt_libshared_library("libgit2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"pixi", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end