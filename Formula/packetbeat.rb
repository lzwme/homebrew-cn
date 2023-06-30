class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.2",
      revision: "92c6b2370e46e549acda91b396f665a7e51e249c"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f82dd58725177edcf9ab0a3060be5e02f42175e15c72127bd979948035e6d69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7020bb032e35f5b796b8e9fda19efb8fd74398307f3e783e535dafcb38831f2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "036206e60eb078310ff3ae358f726d4696bf461f2172833cdf0c4af194651d48"
    sha256 cellar: :any_skip_relocation, ventura:        "9822f9d5726aa86055d1d95b3245e41fb8dbbd5107000310ef65fbc0318dc853"
    sha256 cellar: :any_skip_relocation, monterey:       "d2cc162ad385340345f488bf9ec5e83d38d3ac459006921218df338e8197ebe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d96e70b3533182b2aadf1b843f3a736a4fb7460dba5e58b64e7b984f9a68dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c53a37169adc9b930d4429c8ac97bfe5c6b93b2b3dbf4fc03087902d636638f"
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