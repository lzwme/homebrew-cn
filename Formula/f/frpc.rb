class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.3",
      revision: "44985f574dd3924e9cb48a969fddbd72b3afe2b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c255215f944b9035ca9145f3e24efbb8ed613468e4768455939fce5fcdfe4c4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c255215f944b9035ca9145f3e24efbb8ed613468e4768455939fce5fcdfe4c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c255215f944b9035ca9145f3e24efbb8ed613468e4768455939fce5fcdfe4c4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0193833c07b3bd37cab664167d0b29a493dfa13b14fc998b753c137b2d7b3ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b0193833c07b3bd37cab664167d0b29a493dfa13b14fc998b753c137b2d7b3ed"
    sha256 cellar: :any_skip_relocation, monterey:       "b0193833c07b3bd37cab664167d0b29a493dfa13b14fc998b753c137b2d7b3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b018a2ec699255936179e3ddb0804ada1d900a61c05e163a27a10383c366293f"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.toml" => "frp/frpc.toml"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end