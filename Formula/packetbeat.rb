class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.0",
      revision: "dd50d49baeb99e0d21a31adb621908a7f0091046"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6116e99a7d7e1850ae9c48eb6e8709609ebfb2ba546a696dadb1c3f1141fb59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51a4e724d6b7a6340d4a1dca2a3c11266751ac78b1ca9f7f209698a369a025d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d68e6d3be027f769732414f625f41a48e24573e96658016fb49cee0e7b4a19c"
    sha256 cellar: :any_skip_relocation, ventura:        "4febc2285083cd9ad0160c1c6e36fcb68b1e21401acbcb2e2b03125f478896d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7ed0456fac926db1b79424539a04120b1152facb1c21003d40a8991852ed58ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5a53abb7ff90f6b2b19e1291f67fd761b2fa519f20c123ac7a439600c4229b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88cb65e8262c6c8606198956a914bbf1328b919351395fb29f56ca4e7dbca3f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS

    chmod 0555, bin/"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end