class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://ghfast.top/https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.25.tar.gz"
  sha256 "d921adc7422da2a8c94e53dac4fa0443e3eeb5f55da1fe6a36025df17178d021"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13bbb1e1c07716b1b36ba35ae1262b0381e4545bc19cf86282583bd7186efc9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbaef69f84dcdd5fdd034d4022448df41bd6c89a0e162a762641decec1907cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc8b5343e2172bcc9427c0871bca2f7bdce74aa922085cfacc916b02b2d38d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a77e7ea3bb30685484a372aec889bfc1c16ff1b20dfdedbe458f8e5f5df8ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5be4c70f249a6d667f3e39883edc7cfd4336313c286465ed8866f8e81506a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110635d2f46cb664903c85f14f37e2857abe2d86b3178ad218864f4a9585f7e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

    (buildpath/"config.yaml").write <<~YAML
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}/mihomo/config.yaml.
    EOS
  end

  service do
    run [opt_bin/"mihomo", "-d", etc/"mihomo"]
    keep_alive true
    working_dir etc/"mihomo"
    log_path var/"log/mihomo.log"
    error_log_path var/"log/mihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mihomo -v")

    (testpath/"mihomo/config.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end