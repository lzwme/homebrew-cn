class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://ghproxy.com/https://github.com/antonmedv/countdown/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "ac83ec593674a367913413796e8708680cbb6504c8f68ce17152d800a92ccf3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38a5941ae73ed1aceb80861659045b316492a0ca982022a747912f8585a67895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38a5941ae73ed1aceb80861659045b316492a0ca982022a747912f8585a67895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a5941ae73ed1aceb80861659045b316492a0ca982022a747912f8585a67895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38a5941ae73ed1aceb80861659045b316492a0ca982022a747912f8585a67895"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddf45211af332196f188371a462c0af25b115d64e08d568c20370e5be9992b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "ddf45211af332196f188371a462c0af25b115d64e08d568c20370e5be9992b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf45211af332196f188371a462c0af25b115d64e08d568c20370e5be9992b2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddf45211af332196f188371a462c0af25b115d64e08d568c20370e5be9992b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3d5f2c9b3e7e4661b7aa92583175cd869bcfc37750b4a66dcb3e641be91554"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end