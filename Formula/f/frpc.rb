class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrp.git",
      tag:      "v0.53.1",
      revision: "2b83436a97995a9c9d3232ecc88176f83873fb88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94aa67e36bf46ed1abdc120b2e31791a4c13b2d5adfa7034803a115084f350ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94aa67e36bf46ed1abdc120b2e31791a4c13b2d5adfa7034803a115084f350ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94aa67e36bf46ed1abdc120b2e31791a4c13b2d5adfa7034803a115084f350ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "099b555ea7b3c3ee9efb15ba6bda9581882dd966445624438c9dc729a20600ab"
    sha256 cellar: :any_skip_relocation, ventura:        "099b555ea7b3c3ee9efb15ba6bda9581882dd966445624438c9dc729a20600ab"
    sha256 cellar: :any_skip_relocation, monterey:       "099b555ea7b3c3ee9efb15ba6bda9581882dd966445624438c9dc729a20600ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c81358eec84d9e6b837f087cbb163d3bdecac543543cc30445aa39643469e29"
  end

  depends_on "go" => :build

  def install
    (buildpath"bin").mkpath
    (etc"frp").mkpath

    system "make", "frpc"
    bin.install "binfrpc"
    etc.install "conffrpc.toml" => "frpfrpc.toml"
  end

  service do
    run [opt_bin"frpc", "-c", etc"frpfrpc.toml"]
    keep_alive true
    error_log_path var"logfrpc.log"
    log_path var"logfrpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}frpc -v")
    assert_match "Commands", shell_output("#{bin}frpc help")
    assert_match "name should not be empty", shell_output("#{bin}frpc http", 1)
  end
end