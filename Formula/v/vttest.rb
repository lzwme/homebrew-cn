class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20241204.tgz", using: :homebrew_curl
  sha256 "7010c32b6425968ecd7eec43d89f2c6c674494f73b22c8e7c66dadf21c231bff"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f4b3b798319aa25e544016561503604e05dbfa6cc6ab06c7cac2b7cb7e9aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f716600bd8d1bf50a15f89691f5f865fc208407c0e57a0252e17f46dcdf87ab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eea72f665e8865e84c0600ade1c2be8bde4730cd28bd3ee3139cca12ff502e93"
    sha256 cellar: :any_skip_relocation, sonoma:        "da1330ee7b6c0d892a5639f26cd1f9045c975596e50f9156458c6fbef9377bcf"
    sha256 cellar: :any_skip_relocation, ventura:       "2a01bed98535106e6c806c6ab6b98b94f4ae6013e18616ade73e8383d379fe37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0f9956c0d22fff97dde0300de6203b26fe603a0d9c16697473c8127b5d690c5"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end