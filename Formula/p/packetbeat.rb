class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.2",
      revision: "46e1e32d1aac0400a852b4565f184e23ab03e0e1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "193633c097a0703d442734a2b61c6f375123c7ef3ec2d7b23c6672ff0d239d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d665d0850c3327af8f626554a8005799082136b1e50b297e4e2b054ef1e38824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff2142fe17237f3647f67218b87ce9cf3761ee75fa2a14a7383dce250414c9c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3dc381b5f0cc8c6630d324b104a69a8cce5622d079d964017149d3709ca2fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e220ce8931a4ac930951ed7a5f885e5f4e3479f72890ddce406cff0e35cc2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2179c76dda54c04d739aa96d3c4d13c5af0cd91318f7ab7abab4ed15f22ec220"
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