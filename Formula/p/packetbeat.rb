class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.12.0",
      revision: "27c592782c25906c968a41f0a6d8b1955790c8c5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffbfe68843cea6826854ad9f7bd371952c5277a33bd7f9fd06089fffb58092da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "229446e090b55c1be2a05eda29007b067f1bf554edae6d2ac8b5a0ab12d11a7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c71e7166ed4ff65f702da2f6ae1daa3c400f5d7a042b9594b701825533a33fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "799f37f3c791a03ea38ac9d7910279b0cc3fafc9b19c5bf10ec93afd2e5b79de"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a666d138ed64c137f85cb8e66fbe34c89b0d4bb825e00483a5d69b888fc6eb"
    sha256 cellar: :any_skip_relocation, monterey:       "9f45391827aef7883e32f6e87b3e456eba36a5c7ed013a3bab8fc38b86cd2209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8771d936048d4631032e0c649e6b0f74a2ec2f55a97029df9a8e6b3f603869"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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

      (etc"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec"bin").install "packetbeat"
      prefix.install "_metakibana"
    end

    (bin"packetbeat").write <<~EOS
      #!binsh
      exec #{libexec}binpacketbeat \
        --path.config #{etc}packetbeat \
        --path.data #{var}libpacketbeat \
        --path.home #{prefix} \
        --path.logs #{var}logpacketbeat \
        "$@"
    EOS

    chmod 0555, bin"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}packetbeat version")
  end
end