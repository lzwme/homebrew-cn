class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.5",
      revision: "49b225eb6f526f48c9a77f583b772ef97d90b387"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f1ca56e6dca93063241a185ff14e9143272d17b74fb390b607a65cde4474870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3940feaf5905d3f260f3be789a738b2c3e1369b5e28b958968fdf46c41283c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d6dcfd9849742fcf77ba7c8f6b677a5edbeb4e7e72ca52eec4fc68bae22ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d138fddcc96da16fb62dc5be8602d2507ed0abd093a5f5b9a6c13e2b85392a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd1a3b0a3cd6da7efddc150749d66b7f6e6d59c192d01d7ae42e354e5e33911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ae368bd66bdbd3673bc92eb32ca5d7ad345d267883110382cd457e3b09efb0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "packetbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", ", includeList, fieldDocs)", ", includeList)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      pkgetc.install Dir["packetbeat.*"], "fields.yml"
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    SH

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