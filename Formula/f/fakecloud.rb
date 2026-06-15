class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "3fd6e838d92df4ddaedbd79f8bf7d6aa677c1f7fb1e51c4ce02185061d57133b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dda81bc5b738f4935e9070c4892f2564b0d4202573f3a23248a3b0813db57278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "851d6ee6174dfb5e4297468d7ae5bb09120dccd191207262081e9713dd0503b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9ee9a9936402f8d71b35068bbe69f83b59a71cd2f3f3d6b8827e5e1d90b3f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea2d0be54d2ad29ad2722800bb6dffb3fbf4180f941219f58e31b648016cbc4e"
    sha256 cellar: :any,                 arm64_linux:   "bf0dead358f6dea3363fcceb61184013b740fe0358e8a53c04d65c01e78cbe9e"
    sha256 cellar: :any,                 x86_64_linux:  "e12f2aab1516bd2cac3f6cd92289053bf3cfb27f710647aa491dcb337867a2b9"
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