class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://ghproxy.com/https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.16.02.tar.gz"
  sha256 "71ac375826cc58dcbcf5f1609959ed1a5afd71192c52025b5cb273baa3df2317"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51f7090a063f0d7d824f51272049f946e99c2ec2484fa03b093678c7baa0adb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d8bfdef0162ce89866c89430be053fc8e37c4ff522eb984793d65a40ebd6679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "196572107593ecaacb22518e2759aad6e689a5008e545d7b941a849cdb9e21a1"
    sha256 cellar: :any_skip_relocation, ventura:        "db8d72ecc1198837cf72a9957566bebcf6c9fb8b5bad5cde365e99549c87728f"
    sha256 cellar: :any_skip_relocation, monterey:       "2304dd58fbbbbfa087b02746f8d5f93af96ea76e075d4302f2fb88095c15df8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bc83dff3bbc57abae69d5aaf075097377bbf0587ae3b542c8b668240aefb1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acb5663e5614614ceee344de3559a53ef24f888996cdd88a029a68da5377c898"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end