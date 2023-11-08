class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.0",
      revision: "d3facc808d2ba293a42b2ad3fc8e21b66c5f2a7f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b9718528d86ed61e5b053a6da4dabe6d6e54ea13b8e2a6b895743a953c5641f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6c598d14e6be148d2de1377f0ef4e414ba1832812d846b14b317e624e452ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c27ea00e83f0153761c3b69dba00873dafde86aafdd068cd03f23c81b3f80ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "0600d3e68b7892f5a8ae4c8f8b111f61305bbe7d73a522ba8797798c4e090526"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0cf25241fecd37fb5b63e0763c5c7b222fbde582b942ac20d0380f1cfbfa36"
    sha256 cellar: :any_skip_relocation, monterey:       "a71f49764cdb3fa44e106a7d5223cc48ceee1273558661ae563ec627efca9020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c90f4f609af778435ab48c676a8b898c0a6dc43fecd49261bdfcad754b0ac9"
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