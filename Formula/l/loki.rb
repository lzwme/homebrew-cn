class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.3.0.tar.gz"
  sha256 "b36148586da9f8b58dc0a44fb3e74f0d03043db2fcf47194bc9d145bf5708b3e"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e2e673b9fc75631cb99267c8498343b1a66e22cc4b2c4988dc7350734ee76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf2f57c62581fb8c34a886acde7144a2467267b67a28eb90ea38810a64221f24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e526b4dd1af4b85e363e1e0c82910855b4f804ddac6beaa973a0b6aea9d9004"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4212c0bb0aa91ee726c260a69ce11a11fad1d474b0d94136d82ebf1d9ca7258"
    sha256 cellar: :any_skip_relocation, ventura:       "6a22bb6baff0b8877676528df047741db53fd6dc3a22a902751f6a6e373eeadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e1323cf8dd0f69a577e278a91e4357f6c7093cf92428c72ef264b035f1828a9"
  end

  depends_on "go" => :build

  # Fix to yaml: unmarshal errors
  # Issue ref: https:github.comgrafanalokiissues15039, upstream pr ref, https:github.comgrafanalokipull15059
  patch do
    url "https:github.comgrafanalokicommit5c8542036609f157fee45da7efafbba72308e829.patch?full_index=1"
    sha256 "733203854fa0dd828b74e291a72945a511a20b68954964ad56c815f118fc68d6"
  end

  def install
    cd "cmdloki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin"loki", "-config.file=#{etc}loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var"logloki.log"
    error_log_path var"logloki.log"
  end

  test do
    port = free_port

    cp etc"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin"loki", "-config.file=loki-local-config.yaml" }
    sleep 6

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end