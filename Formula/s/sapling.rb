class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://ghproxy.com/https://github.com/facebook/sapling/archive/refs/tags/0.2.20231113-145254+995db0d6.tar.gz"
  version "0.2.20231113-145254-995db0d6"
  sha256 "e927c386336ddd047d36a33d6dfb06286960d9c2a56c843fbb2d5ed1ecaf749a"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cd67b8e188d58e58014082cfcce5061bfaf942983de0a5f9867ffb8b18711e6"
    sha256 cellar: :any,                 arm64_ventura:  "27d68c803ffde407eb6bc55e957b7803440be27825252ed685e9b1d714f62adb"
    sha256 cellar: :any,                 arm64_monterey: "39ee1cb6a31e9a63961531c0ecb39efe171f3e05e5f9ea65f33908811ae1536b"
    sha256 cellar: :any,                 sonoma:         "376aeaa170e95f0fa05a98f030bedf3e2f13c133e679ac5127e594de8f5b6619"
    sha256 cellar: :any,                 ventura:        "b66a5dc6c37d423889af8756162ec34ffe7131f89909a4f030f724cd81e76f51"
    sha256 cellar: :any,                 monterey:       "dc71b96d8ba1324485b8edb3a724721dc7ce026a946a342f5bc505f2c4da27ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100ee712048709028dff1056c55052a5c9e5c8e053eb11a702b8461a52576afb"
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
    # will get a git repo, we can use the ci/tag-name.sh script for determining the version no.
    build_version = if version.to_s.start_with?("HEAD")
      Utils.safe_popen_read("ci/tag-name.sh").chomp + ".dev"
    else
      version
    end
    segments = build_version.to_s.split(/[-+]/)
    "#{segments.take(2).join("-")}+#{segments.last}"
  end

  def install
    if OS.mac?
      # Avoid vendored libcurl.
      inreplace %w[
        eden/scm/lib/http-client/Cargo.toml
        eden/scm/lib/doctor/network/Cargo.toml
        eden/scm/lib/revisionstore/Cargo.toml
      ],
        /^curl = { version = "(.+)", features = \["http2"\] }$/,
        'curl = { version = "\\1", features = ["http2", "force-system-lib-on-osx"] }'
    end

    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["SAPLING_VERSION"] = modified_version

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal("Sapling #{modified_version}", shell_output("#{bin}/sl --version").chomp)
    system "#{bin}/sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system "#{bin}/sl", "init", "--git", "foobarbaz"
    cd "foobarbaz" do
      touch "a"
      system "#{bin}/sl", "add"
      system "#{bin}/sl", "commit", "-m", "first"
      assert_equal("first", shell_output("#{bin}/sl log -l 1 -T {desc}").chomp)
    end

    [
      Formula["curl"].opt_lib/shared_library("libcurl"),
    ].each do |library|
      assert check_binary_linkage(bin/"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end