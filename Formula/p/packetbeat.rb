class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.1",
      revision: "f17e0828f1de9f1a256d3f520324fa6da53daee5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e878a52e942b9b174db2a4340fb425f017c2f7bfa0cbccc75d9b74a94edfb63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f1228bce8639962d014b8db6a27159307cd42f826eabddf10030ed6db3bff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c196c4b02c7add9ae6e05d025946195412e941d9d60cd7381e252c33e73cca0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f585040601d89d3576d0701ff1c63f3279bb446ae974fd155ca7fac73e761bb4"
    sha256 cellar: :any_skip_relocation, ventura:       "6cb3de68e792b4ef263c981800a6f934c1b974386bffd3717bad605075708e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2a84e128d2a7e3f98775ed1a8b5f40b396956a743c039619362c7338fe94b0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

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