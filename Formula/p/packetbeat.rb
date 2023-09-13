class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.0",
      revision: "62873ab51c9cb5492f3f2b1ec597396071564737"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b3b42214b95b129b85ceeaa5b674322b4a6a61b20aaf4e03262d2aa75dbd20b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed618fda16d9b04bd1b74643e3a1ff1d1ba582285c1a615f826d649927c0c620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6471a28ebb8f41838d66f341f671a5c419e2101e5d46896a7fcc5a8548477292"
    sha256 cellar: :any_skip_relocation, ventura:        "c54921fa3e6508ebf02fdf8ece932485899b790ef25de6d8d1de37eb7ca91a55"
    sha256 cellar: :any_skip_relocation, monterey:       "155df120e8431fc100fda64b559bf74849313150f74c4f4b94e6cc01db5a8694"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c6720a7f4e45084b209f79791c9194a7498fb0d929c5a4dc6a95875a3a26a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc7a53cbdb054f9cb7ead2d7a8fc93f1dc5c9ef1e8cbae1e4131758a7aece05"
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