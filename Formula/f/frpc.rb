class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://ghfast.top/https://github.com/fatedier/frp/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "bbec0d1855e66c96e3a79ff97b8c74d9b1b45ec560aa7132550254d48321f7de"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de9d1c92a7d52f6eb21277ef474eaabf47a86ddb216cb070416e80d437dd96bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9d1c92a7d52f6eb21277ef474eaabf47a86ddb216cb070416e80d437dd96bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9d1c92a7d52f6eb21277ef474eaabf47a86ddb216cb070416e80d437dd96bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "118d30a66783cb6990cf3c5ec429920093d516c93cf928ebe3012c8f6dff9ee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376bfeea2aeb168678cd41a776ff8dc00b06297116601135dc8a837f82a85849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e970421ff11785b998f80966a826b6c4162a73157b6d820f6a6b2f94f4a4ec6c"
  end

  depends_on "go" => :build

  def install
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