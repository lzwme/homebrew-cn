class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.0",
      revision: "ae3e3f9194a937d20197a7be5d3cbbacaceeb9cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "752d3c5464211050a4991e3efe26130d6ae1c225284931659a12b2550cc067c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69e21b1fa4dba11ffb1e21e304a9441ec3eb3f662f69375c82f669542779b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b23271afab8f4d8e49aa3a632f7445e81be6ffb6b15506881fe0ae8f3f97e2e"
    sha256 cellar: :any_skip_relocation, ventura:        "64b986872f12e449824a15df95fad35d56e187d5e06f5748d79660dd46103c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "ae1ba4f786e6890ff7a2882aa2422b21b4c9603a87e28cd7d1d4943fc34c924b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0733d6032a88e81c9cac52e88d2c567c7956944303fb89487c115b5e57dd88bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5544ec8cbfc8004b2ed627222a5b07ec032ecd23fcfedb5d482c57dbaaf4b440"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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