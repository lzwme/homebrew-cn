class Sapling < Formula
  desc "Source control client"
  homepage "https:sapling-scm.com"
  url "https:github.comfacebooksaplingarchiverefstags0.2.20240718-145624+f4e9df48.tar.gz"
  version "0.2.20240718-145624-f4e9df48"
  sha256 "8081d405cddb9dc4eadd96f4c948b7686b0b61f641c068fc87b9c27518fb619e"
  license "GPL-2.0-or-later"
  head "https:github.comfacebooksapling.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+[+-]\h+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0decf820322e2c3f04ef4c4c9f0e00face07f5c21d2d1f131450a734a89a4de5"
    sha256 cellar: :any,                 arm64_ventura:  "57f4adb287b0759ae2cee40e0c3f677a7e0d2fa7c9b77853258899740cbe6068"
    sha256 cellar: :any,                 arm64_monterey: "552a80249070c4ee360ddc4ec3e68b45b9b65ee30b85a1d76a391e7c47ff2af0"
    sha256 cellar: :any,                 sonoma:         "0e96c8d0ac7abb5c2ca7fcf37772c117d144d83c2af6f3388e6c3cc6092f26d3"
    sha256 cellar: :any,                 ventura:        "764c246bdb5b87e9144254fce544832fd8b54093554d2f6937e504bc5deef1b8"
    sha256 cellar: :any,                 monterey:       "28fcc5bfc9a422a6f1879151228703a8bdb64bae6da5c7d8587aa762be023be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f5fc14e617b112268e3302dc57628dc3ba5bc50fa52a038faaba4ed79cd396"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  # The `cargo` crate requires http2, which `curl-config` from macOS reports to
  # be missing despite its presence.
  # Try switching to `uses_from_macos` when that's resolved.
  depends_on "curl"
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build # for `curl-sys` crate to find `curl`
  end

  # `setuptools` 66.0.0+ only supports PEP 440 conforming version strings.
  # Modify the version string to make `setuptools` happy.
  def modified_version
    # If installing through `brew install sapling --HEAD`, version will be HEAD-<hash>, which
    # still doesn't make `setuptools` happy. However, since installing through this method
    # will get a git repo, we can use the citag-name.sh script for determining the version no.
    build_version = if version.to_s.start_with?("HEAD")
      Utils.safe_popen_read("citag-name.sh").chomp + ".dev"
    else
      version
    end
    segments = build_version.to_s.split([-+])
    "#{segments.take(2).join("-")}+#{segments.last}"
  end

  conflicts_with "sl", because: "both install `sl` binaries"

  def install
    if OS.mac?
      # Avoid vendored libcurl.
      inreplace %w[
        edenscmlibhttp-clientCargo.toml
        edenscmlibdoctornetworkCargo.toml
        edenscmlibrevisionstoreCargo.toml
      ],
        ^curl = { version = "(.+)", features = \["http2"\] }$,
        'curl = { version = "\\1", features = ["http2", "force-system-lib-on-osx"] }'
    end

    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["SAPLING_VERSION"] = modified_version

    # Don't allow the build to break our shim configuration.
    inreplace "edenscmdistutils_rust__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "edenscm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal("Sapling #{modified_version}", shell_output("#{bin}sl --version").chomp)
    system "#{bin}sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system "#{bin}sl", "init", "--git", "foobarbaz"
    cd "foobarbaz" do
      touch "a"
      system "#{bin}sl", "add"
      system "#{bin}sl", "commit", "-m", "first"
      assert_equal("first", shell_output("#{bin}sl log -l 1 -T {desc}").chomp)
    end

    [
      Formula["curl"].opt_libshared_library("libcurl"),
    ].each do |library|
      assert check_binary_linkage(bin"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end