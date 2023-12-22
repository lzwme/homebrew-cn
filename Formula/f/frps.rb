class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrp.git",
      tag:      "v0.53.1",
      revision: "2b83436a97995a9c9d3232ecc88176f83873fb88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7531a4025422fecca1e0113d2934a1e97e0e0dc43321372e28541a67bd4a9563"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7531a4025422fecca1e0113d2934a1e97e0e0dc43321372e28541a67bd4a9563"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7531a4025422fecca1e0113d2934a1e97e0e0dc43321372e28541a67bd4a9563"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fd306789b5f27c186fd5e5f21b39675b03721e8af7384c2592220d4e2091360"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd306789b5f27c186fd5e5f21b39675b03721e8af7384c2592220d4e2091360"
    sha256 cellar: :any_skip_relocation, monterey:       "5fd306789b5f27c186fd5e5f21b39675b03721e8af7384c2592220d4e2091360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdbf010c202f3ecfb0d7077328ce0b1dd15e09a2f20bf264a8b9feb975ea2fa4"
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