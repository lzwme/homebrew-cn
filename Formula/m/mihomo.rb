class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://ghfast.top/https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.12.tar.gz"
  sha256 "9f2d029f7d074cb2f0f9c7bc59f47fddf48bd9ce2ce3532cd91d00fd89ee25f7"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6da66ffd6900b9d060067c76651df38f57c2ef25ec35b50812a8da9658c6c7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6cbed0a8a1fca125db8f03dfb2728e7ab5932d59ccdf32dcd842f8bc829ae7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b0684c25802317caa3538f36c7ac844e7b5f1011e53ea27e6718eb70f645241"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8dc1dfa9915dc842caa1cc952ed0efc80162849303a3044ce0770a66f8445da"
    sha256 cellar: :any_skip_relocation, ventura:       "b977fa28987d8e8fb51198701696d062758fc1ba45220c94ab49cdafa92efa5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8269f6ef6c4bd11d887e62d7d8938e1a617bfa33f85abf1209dd4a7db26f8696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1d832d29f90b2a50670a2b1addc26568410afd6492669e226682a8ebe5eef4"
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