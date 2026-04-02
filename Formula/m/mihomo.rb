class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://ghfast.top/https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.22.tar.gz"
  sha256 "65a0979c8223608808167dddb39571676e8ca5d907c20f57244aae1d595387c4"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0953e371a021530d1337d4118edcda2273f5506bc1bdd5bd2f19fcaf17fe9db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0953e371a021530d1337d4118edcda2273f5506bc1bdd5bd2f19fcaf17fe9db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0953e371a021530d1337d4118edcda2273f5506bc1bdd5bd2f19fcaf17fe9db"
    sha256 cellar: :any_skip_relocation, sonoma:        "30b4e13b282328596185a55b8d2879dbb18d3407714107f1b86e09f1aa8c24b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "423c3206d80e994311813e75dacc7f0f141d9fcadc44f40723ec1c823e22bbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9438a9feb2c73e639883da555c7ae63ae8df2b634add16d03946a98f25ad3b5"
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