class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "c9699f2f0ca73a81167bf1f13b9420d55e554220fe5d09064b943da8921841c2"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e85e5624636eaa692ab8486812140feb05019eeeae1440e7e76ebf48c3bb8c40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d693210efd96e37ac6cd251c24703151602d0f7384bfb4dfaf4c281a73f5e53c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88491362ff185a4c14fbb9ec2127fa61da559011721371f96782205941cb9f46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d754e1694594a548017ce750daea21d2b957e3599ac66d2416667a197bb596d9"
    sha256 cellar: :any,                 arm64_linux:   "787a141595e953af2abe2a56b00476b8badd17ce4959b91546a20e971357301f"
    sha256 cellar: :any,                 x86_64_linux:  "92045454fe915677485674dfdabcf551c1cb4153648c91973459619b99218a38"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end