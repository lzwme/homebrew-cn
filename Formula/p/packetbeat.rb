class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.1",
      revision: "ba6a0bcef9ec28790a10888070eab35b95277e38"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b54c135f09ecf735c2b8dac897b27bafc37304c7ccf047d8c1e650f318f8845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fa6b8f7040a96cf970b27eb7eb6dfbcc93834565bf1093577c0b42488ba920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18b21792793c478e38b601211bf0d8fce9a6845e966190fac027d854e9fb3ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "8b1667d91ce3e867def2c104cc56290d9ac4d2b436bd2df6f5a49e2ad53f4488"
    sha256 cellar: :any_skip_relocation, monterey:       "df5e8d1397f449507a5756a44b1febb80ed8c1065fe1a68180f4222a342bab2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "74213c810ce0101d5151118ec96f69c62fc2d5c541caba198b8c7af1d8844284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0021b9cdaabea9fe62304969309c9b195d158c2cd412f5149c572f625c6d033a"
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