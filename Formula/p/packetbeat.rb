class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.1",
      revision: "1292cd58f48325c041317d9a8bc1f1875bc6cf5f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3c7586f65fe817034b14532d4e9199f9356e20fe196effbec40a04820b7820e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fab3aee9e4f14bf79eab1bae5e9e2efaa09790138842aae7e48f9465f3d5fb29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "113d3f520745a97f60a271f3cd076398925b7ec7b8a27a7b13963f59da514f64"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fb75e8fa74c13026ad7bec3f0ab3f4f60928337fc343cfbe06fe343207a17b"
    sha256 cellar: :any_skip_relocation, ventura:       "a489a0f05347e539cfd5d404ea3996d6af3b747d511f6d0e53b430f38edb0617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01b4f2ed6eeb5e5523b0c685e62f33445470228723acfd636691266e1c8f94b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09853785bb2ce410e274b02d27f00cb31628ed8475a3d501973f25a12fa8db03"
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