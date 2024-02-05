class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrp.git",
      tag:      "v0.54.0",
      revision: "d689f0fc531604b78b510c2f5f182831a2b5bee5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fd7a94afc73f550e605f1cbeee5d477c3e59f8cb112c708985d92f9b5a99a40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fd7a94afc73f550e605f1cbeee5d477c3e59f8cb112c708985d92f9b5a99a40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fd7a94afc73f550e605f1cbeee5d477c3e59f8cb112c708985d92f9b5a99a40"
    sha256 cellar: :any_skip_relocation, sonoma:         "105cf04d3c9859477b629b4b73a01fef9869686f5ee40c761d2ac0deada624b0"
    sha256 cellar: :any_skip_relocation, ventura:        "105cf04d3c9859477b629b4b73a01fef9869686f5ee40c761d2ac0deada624b0"
    sha256 cellar: :any_skip_relocation, monterey:       "105cf04d3c9859477b629b4b73a01fef9869686f5ee40c761d2ac0deada624b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7aacee1d87c3771d1c152314cc48b8cf187d284e581e6f7dce0a5e66c95b18"
  end

  depends_on "go" => :build

  def install
    (buildpath"bin").mkpath
    (etc"frp").mkpath

    system "make", "frps"
    bin.install "binfrps"
    etc.install "conffrps.toml" => "frpfrps.toml"
  end

  service do
    run [opt_bin"frps", "-c", etc"frpfrps.toml"]
    keep_alive true
    error_log_path var"logfrps.log"
    log_path var"logfrps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}frps -v")
    assert_match "Flags", shell_output("#{bin}frps --help")

    read, write = IO.pipe
    fork do
      exec bin"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end