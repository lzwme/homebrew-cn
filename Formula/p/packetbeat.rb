class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.0",
      revision: "8d2ab535d12bc41211d0dd62e244fb0cb6882e3c"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62a55fd7a702615f95087bcaa46c9984552af43f966560475d687d8ad5b67d95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6707334b6269b675ad4c0ca3f42edb2a942a985bdd613f896752daa2301f4598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce5941f5bc389d01c350cf1f4826908a8afab55576c7b0946d4f204b06c75a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc4a10dbe014646f96d35a998a900c15f0efede13ac24bc69c5aede2da6cd663"
    sha256 cellar: :any,                 arm64_linux:   "7413a3f970e57c2ee7c9eb1541e8ce6d49933c0f70f2d90f124fc2f554b7cc72"
    sha256 cellar: :any,                 x86_64_linux:  "3d4a0160fa265573cb78be80733cac92faa73b6aac4076a1608dfe58f5ff36df"
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