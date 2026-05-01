class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.4",
      revision: "4ce96ccbcbdd9b4f149e1af9ff2a48af7f42ade8"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b98dd8e2817ac2d0808d866cf906c2be1e7a4c42cba07b3a6bea37ff2de69f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f214fa9c7790d80f57c495fb1a64a3e71a3c5558f9848af003fc72f3f3e42392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a392f95bf246c5f66a9a91c197b016570bc5885a84edec2be46e24efc10fcb62"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb052d6fce9925de006f5fa2f8613724a3172e79c33a8435a71aac3a35e823cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf781c03aefdbb77656889c68dc1a7abc862d23bd2ec8c2022e590b43925808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8599e835df09fd16b538ad4db0495d64cf9bdf403ce9b6ffb9a6121ea6acbb"
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