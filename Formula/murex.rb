class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.1.3010.tar.gz"
  sha256 "e6e86a7cdc709fb733537552f5fad8d3f839dc80c5877f883f4d26fed46d35bc"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54ca7594d42847a82a448f189b1d625f04ceb402276c572ee539ce5099dab030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "268595923581bd7b52e9ae47cd8e6d3d85206e66d967907419a0a732f1f7168c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41edc30111286016321e9018fe532bdf3ed36fc544048b6c405a6f656f887b0a"
    sha256 cellar: :any_skip_relocation, ventura:        "9b2688736fef0cd1e70627949e5f44198605b9e7a15ea605bc7e035af71c7b86"
    sha256 cellar: :any_skip_relocation, monterey:       "c09c98e2bae67ea1bf31d1fc0f40f71146cd61092db2fc43c672021b1c272d81"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f636259942287dd3dad6def65f39a354fe50a27a9b784ef7877e127ac47e10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe315ae3a199bd88af5f455c10586e948b8c94f470d821eb4dda04ccf4b12d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end