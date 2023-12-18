class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrp.git",
      tag:      "v0.53.0",
      revision: "051299ec25638895e36779c305abf554671b4f68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f23f7b56d4d5f4ebff8cecdfb4f7b5b76e89c0b7b8202cdd0f609652c2ebd9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f23f7b56d4d5f4ebff8cecdfb4f7b5b76e89c0b7b8202cdd0f609652c2ebd9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e8a334fd175ca6bb80d735c7b54e6b0880b4111103c79623d882580ccf32d0"
    sha256 cellar: :any_skip_relocation, ventura:        "79e8a334fd175ca6bb80d735c7b54e6b0880b4111103c79623d882580ccf32d0"
    sha256 cellar: :any_skip_relocation, monterey:       "79e8a334fd175ca6bb80d735c7b54e6b0880b4111103c79623d882580ccf32d0"
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