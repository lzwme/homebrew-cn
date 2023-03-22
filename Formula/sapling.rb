class Sapling < Formula
  desc "Source control client"
  homepage "https://sapling-scm.com"
  url "https://ghproxy.com/https://github.com/facebook/sapling/archive/refs/tags/0.2.20230228-144002-h9440b05e.tar.gz"
  version "0.2.20230228-144002-h9440b05e"
  sha256 "70483afad6d0b437cb755447120a34b1996ec09a7e835b40ac8cccdfe44e4b90"
  license "GPL-2.0-or-later"
  head "https://github.com/facebook/sapling.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81ce8fbe45bff3a224f222721285cfca47fd1242450794177ba89c26990b73b6"
    sha256 cellar: :any,                 arm64_monterey: "bf9fff95329e7566b8e360d3e97502e1c28da451e092384f8f92690b91020292"
    sha256 cellar: :any,                 arm64_big_sur:  "d62418cf83a04d4f9f697c4ca9a118b9fb47ca2759960e076ecd6adf364063d0"
    sha256 cellar: :any,                 ventura:        "0a0658ab70813bc55303f4a0500a930b91097e85e4e462d9b444092e4957b912"
    sha256 cellar: :any,                 monterey:       "3c07d812648bd8c15d8c2da0310749885b8f5ce059b44f9ecd06a982225c29c9"
    sha256 cellar: :any,                 big_sur:        "cce358b4e7fe42b350d9e1286708f4e2f91a12b247921dea522da9b6e733a3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65eb643584f621fc71758c063d1f59c4750e054cf935fe16832054a606e62188"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"

    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["SAPLING_VERSION"] = version.to_s

    # Don't allow the build to break our shim configuration.
    inreplace "eden/scm/distutils_rust/__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "eden/scm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  test do
    assert_equal("Sapling #{version}", shell_output("#{bin}/sl --version").chomp)
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