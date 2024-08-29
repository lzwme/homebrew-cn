class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20240827.tgz"
  sha256 "fff212c8eb08cbe28235ac5f7fdb68cea3f78f103214c82b8a0a785c33aaed25"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64eed95af02cf55b3ba96db5c03dcee200c25661e05bd88190f3595c10b392d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bafa404b1783553dba6e7ca5b91a6962032ef72e4818fdaa78558fd72451239f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b1e9d4c2dd6b3497eff46e086c29d0a60d4f477cdd6f1b63f4a4e2d1d17eb09"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a894a8994701c5763dbecc83055aae4fe98cf3820589c6084cc4dd9721ef08d"
    sha256 cellar: :any_skip_relocation, ventura:        "504a40505ead6e657f8a3b4aa76787ff27466c986a33e595e63a7106a3db0874"
    sha256 cellar: :any_skip_relocation, monterey:       "68b67a20567ebf24c892a5945156271cd2391e8a501f9c5ff254dcdcb9861b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a2ed23685d0075b6695428b6130ad96bd4da371d4eebbac0a099df5cee311d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end