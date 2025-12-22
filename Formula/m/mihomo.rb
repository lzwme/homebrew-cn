class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://ghfast.top/https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.18.tar.gz"
  sha256 "270a8b6904b6c1bf84ed01fab30a3d78d6523564c442437cd2fba1162578e585"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09832d888f6c498224a499c0c5d5707e6cf76819f038e6bbe7dade058fedf590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a16e13e6fa7ed224387d41e5ee19b23808e75fd2b8085e70e8b70894a695fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0134c172944205ea6781d92f49970c7b2da9e1bad210c05d6360d22303a33e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b92c644c14d62e0839796362bba6a1101d21740fd80d1cb0005ca5158124c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6c615583fde410899d0d3f65de981cc965da1fddd502737a866c87692865377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffa4d6e0d9e3273ebe10210c95af99bdc85be3706b8308ac78d613237a2c7fe"
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