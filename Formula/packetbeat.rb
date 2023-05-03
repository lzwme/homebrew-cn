class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.1",
      revision: "bda40535cf0743b97017512e6af6d661eeef956e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45f7ffe069ce27ce2ba741e43dca6574966383f19c4116b55938107b0ec79a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9b3aab3776ef2b66568824d8e58fed6080d795be59eaf1455d41c81627efe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f7ad2eb383bd6e2deb094c8d6c485619eeb3f958412b30afc415be549a3a9a6"
    sha256 cellar: :any_skip_relocation, ventura:        "09d959fecd0c2a7958a595167303123ac6aecf5750f10b28a97218686f66252d"
    sha256 cellar: :any_skip_relocation, monterey:       "bae583dade5d6c0f953b4a3daf16d8b5a2d04876c8bfcf27c0224f59934e4a2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "17d10eb2f97ad290fa912a6b15f4996f697a7252fcabc2ea862c8513ec7dd1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a9d46caac277d28f4f52ceae99f40cb70cbe68bec6bb39e8999a5bed0a20743"
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