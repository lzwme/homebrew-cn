class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.1",
      revision: "e89803edacde0a21ae1b8aa315f68bee303cf943"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5227f0339cf9cbbe3ea15d97468940c60df2b89f86700d83ee2f74fff0879c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1babec30de2e642733cac385cd05cdd6670835dad2aa5fed1953b31b61df9b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4beba07f611ef3dcb6b5d17a06583c451260a36d6177c548fcf8e3859e3bfa61"
    sha256 cellar: :any_skip_relocation, sonoma:        "5899133fec5fc5bd58f50024716bacfc6d6cc5eae18fbe7bca1a3f8a0adbd2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001d0b24c443106946bd165a4bcfead61c8e1f0f5f792c38fed9ef94259a9474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35090bac7b835bfd6fbbc6c4eba04dda0d3ca67657c36123c7a6bb7011e75151"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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