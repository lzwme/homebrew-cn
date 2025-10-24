class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.0",
      revision: "09b547febe1cc9102a5d3f80ac8fbf68a5fd84f5"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cca3f3be656e193a1c2e4f7a86867adbab5b791c0b5de12f709ece680fc506b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b24265bba3a53aaa5e49ad1b2a14bc841a72d941f443e7b66a0c738fe05cfdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e12b1eb3dde9bceca5e9eea1a83fb63b692f52c50c9e4261cff33a4f63a9716"
    sha256 cellar: :any_skip_relocation, sonoma:        "182ff804bc98dc06fc309f0006a9721ff846bf4728fadb05ab7145fb00903362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f3b2da275c73ec8104b1cc574eb8737150633291f1c5925fe1eee211fdad940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b5e8d922f9d13a811984d2dd0516e532dfae879431766df4196b8063d1e405"
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