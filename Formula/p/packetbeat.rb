class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.0",
      revision: "c53b4a051bee29d3e5b3cda16753ea18d47e339e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165eb099d49033c8a979ff296f097a0200461ae66d59e61e5f06b73316df8747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2b8eeb7ce9c2dd83ab95b4baaa8e5820287a73c44fca7d548afb1c275a40fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fec318f5f996d9dc43f1203e654929abd48f1aa44d71bfe2e094a97418f86f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4136dc484b5d639035084d43a8fb4a7382ccdc5dd20928895a5142a6772a3c5"
    sha256 cellar: :any_skip_relocation, ventura:       "930d4457b3333087dacb08bdac4801a82ceb992ae9887d8c9fd5f6581d149308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a138f65975167c8625da7648748dddeb2d7aab654b1ab567f6f714a50fbf3fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf6cf3ee9b5e582f49888ce595d2ddbb14c2d5af5f4b52adff99eb0dd1840bed"
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