class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://ghproxy.com/https://github.com/cjdelisle/cjdns/archive/cjdns-v22.tar.gz"
  sha256 "21b555f7850f94cc42134f59cb99558baaaa18acf4c5544e8647387d4a5019ec"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e9dbce680ded6cbe6b0aabbff2d4a5e06c37a0dfbdd62953b026901230ceab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9936c5967ebb1f708154585ccde1446d36c9eb88c614b59ae42f96c551f3ccd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fa20c4991e09b7d63ebd478adfd07fc90a7d2e3b8d63fb5b4e5e22e92c6fa52"
    sha256 cellar: :any_skip_relocation, ventura:        "021aebe2db8a0b89fca4649612f9d3732c0a83c6f0b3638834289e0802acde33"
    sha256 cellar: :any_skip_relocation, monterey:       "8deb77907b473f50757c022df865fbea0df3d7e91ced2f35407064c8172fdc87"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c3c3fc2c2e62759b79f38e29d6eb8a7518e1c3cc6066c1faa25e4a650b98f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "311f9548b046796d787c72c94a536ca5cf0939319d1a2da502af32d837f2d6c9"
  end

  depends_on "node" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  depends_on "six" => :build

  def install
    # Libuv build fails on macOS with: env: python: No such file or directory
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin" if OS.mac?

    # Avoid using -march=native
    inreplace "node_build/make.js",
              "var NO_MARCH_FLAG = ['arm', 'ppc', 'ppc64', 'arm64'];",
              "var NO_MARCH_FLAG = ['x64', 'arm', 'arm64', 'ppc', 'ppc64'];"

    system "./do"
    bin.install("cjdroute")

    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    assert_equal "NONE", sample_conf["admin"]["password"]
  end
end