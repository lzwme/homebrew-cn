class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https:github.comfatedierfrp"
  url "https:github.comfatedierfrparchiverefstagsv0.61.0.tar.gz"
  sha256 "c06a11982ef548372038ec99a6b01cf4f7817a9b88ee5064e41e5132d0ccb7e1"
  license "Apache-2.0"
  head "https:github.comfatedierfrp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d57fa31ee616a75c5923fc7532641b419252f3ddac4b095768e4faff278a61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d57fa31ee616a75c5923fc7532641b419252f3ddac4b095768e4faff278a61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52d57fa31ee616a75c5923fc7532641b419252f3ddac4b095768e4faff278a61"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34d2faefbed3e2f52b331676c2992b196a18f94075ee50dc3e3149936d2862f"
    sha256 cellar: :any_skip_relocation, ventura:       "d34d2faefbed3e2f52b331676c2992b196a18f94075ee50dc3e3149936d2862f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff1fdba4ab4705d3f8b0d8d37d6d0f17a5e29ca75d741e954320cc138acdf74"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frpc", ".cmdfrpc"
    (etc"frp").install "conffrpc.toml"
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