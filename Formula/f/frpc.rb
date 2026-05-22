class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://ghfast.top/https://github.com/fatedier/frp/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "b78879e74e44bb22805a8a4602c6f58b9f46971c003eb4079d5020f66e57ed37"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa7c0b542d64052fe1ef20793c2b85a2367cecde6b82591c920c2b217a32e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa7c0b542d64052fe1ef20793c2b85a2367cecde6b82591c920c2b217a32e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa7c0b542d64052fe1ef20793c2b85a2367cecde6b82591c920c2b217a32e4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbb9c662db1dd395acca7e5310f653e93b6c099feed114d293c362e7b4fcbced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "257261456f8d068ba0d4e104a8e43e088ae80fbcac05696a22979093719004b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18df22ac3b3516bbeaf1a4912c243deb9539d7820c54bc2c623156bfda5f992a"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"

    generate_completions_from_executable(bin/"frpc", "completion")
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