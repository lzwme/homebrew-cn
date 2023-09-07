class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://ghproxy.com/https://github.com/facebook/sapling/archive/refs/tags/0.2.20230523-092610+f12b7eee.tar.gz"
  version "0.2.20230523-092610-f12b7eee"
  sha256 "57a04327052f900d95d0dd3800d8b13a411b08222307bb141109afca1d1d0eaf"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[+-]\h+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "13d796b6ab41617dbfe6d0f0198220a9773738a1150842ea410fbcdaf4ed3036"
    sha256 cellar: :any,                 arm64_monterey: "21bf1046985e20082d31d9f3112b05d5adff667d89f2c22e83b85a59236122cd"
    sha256 cellar: :any,                 arm64_big_sur:  "20dedd0b47ebd210b69c024c45369b2f88c1d0495c5f7fefc3782f1fa4f1db43"
    sha256 cellar: :any,                 ventura:        "597f06474069628d5f47ff10523410b131454351ed0b78d855e4b49ecb170301"
    sha256 cellar: :any,                 monterey:       "ea66d7d774293cb46710839063c268c2a98e7557df0729bb32f019fbf5d7099e"
    sha256 cellar: :any,                 big_sur:        "9f1afc4de2980f9c13885a02a153d89052a3d100afb5838d00e50b9a79130659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0e6c07133d5bff4dc9f9b7f5dc4fb5e3e6174337524773336570cdc1fce7f0b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.11"

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
    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["SAPLING_VERSION"] = modified_version

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
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
  end
end