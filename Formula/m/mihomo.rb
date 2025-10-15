class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://ghfast.top/https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.15.tar.gz"
  sha256 "ff04b362530ff975521341bb817023332963ee496c32dfe337b3846e8ab9a8ae"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f7a763b9f6d321038fbcb017afa7b5944b82c58da7a55f378bdd6ee06943e28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f350453abe800dad968c0e1583bc32836cbf0bc8b425d4827a9cd4f4c75914e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab63ccf4f2fb87e283b0ada64cafca327ca297fb04d5c7671f484bb90509af7"
    sha256 cellar: :any_skip_relocation, sonoma:        "179033282ac6e4940b4693b4a30d43e8b20f93957acab3241b471a24ed7aa45a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a71a6188387ad414d910e8e9f7fd0cbc154275a9d8a34a4df3e49c54c02aa9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb0c0dd855c5857394b23cc99a64ba8cde41a661986a9ea9bbd067cae1fd4aa"
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