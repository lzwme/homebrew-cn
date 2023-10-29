class Jprq < Formula
  desc "Join Public Router, Quickly"
  homepage "https://jprq.io/"
  url "https://ghproxy.com/https://github.com/azimjohn/jprq/archive/refs/tags/2.2.tar.gz"
  sha256 "6121e0ac74512052ed00c57c363f0f0b66910618ebd8134cfa72acca05b09163"
  license "BSD-3-Clause"
  head "https://github.com/azimjohn/jprq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "456e989dc2308d2cf7aa857dc56b905d0f14b66ab4ac60998ecd9150d5b94b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f2dbc47fc7487845fb45e9d772f335f2cb5c99bd492c7c88a04cefe13e75e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d46ae2ec35cb3e24210ee7d4538d784d25cfa834b108fc5b40a0fd6bca6302"
    sha256 cellar: :any_skip_relocation, sonoma:         "068e618feb94fe52ee7c1a8232145afb5887ef98981e3be46440565f4096ca66"
    sha256 cellar: :any_skip_relocation, ventura:        "90da7091cc8c37b6d52fcbac5838e4c57eafad10d9bc8a79f48ad3e2421f30a7"
    sha256 cellar: :any_skip_relocation, monterey:       "3f25e7a3661044d1f4e0f55eb9138fb17276da16524ab007efbcb5233b68d4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0658a3bde81ba4b7910c118c5828b8df10380a894243b34a19090eeef3144386"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cli"
  end

  test do
    assert_match "auth token has been set", shell_output("#{bin}/jprq auth jprqbolmagin 2>&1")
    output = shell_output("#{bin}/jprq serve #{testpath} 2>&1", 1)
    assert_match "authentication failed", output

    assert_match version.to_s, shell_output("#{bin}/jprq --version 2>&1")
  end
end