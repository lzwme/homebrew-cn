class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.3",
      revision: "b95cc76490c9bb4184f98e0094be4af14b5d7bd2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f0a462c824c55299568c106f6c28b7d17dafa6368938cbe4429d7c18caf2ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277681fd0bf399abb9c65922afbf06e62de2dbd47fd145ff5337df9ccf0a4620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857b404aab1a909841f92b91e5da46530e80b17ff004529e7dfe3c97bc338195"
    sha256 cellar: :any_skip_relocation, sonoma:        "801baaa9f59fb1bdc3fd9fe7e4a3698ce47092fd04d43fac369e29beaac9521a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b283ce276c43198119b657189e339b77c3deb7efe52e94a6dd826feb2e83b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92750b0b233beac464ad8236138cfddbdc82b84437b992b6257ca511b86dae1c"
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