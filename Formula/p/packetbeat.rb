class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.2",
      revision: "ce367ff5456dd8a1a93d6bae8fd600bb04816718"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71935d8707b952ad56a25e4d6914168240be04bf4f545534b71a52b4269ecf60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61ec31f855f7a701fced93eebe16f63b4ababb740ad87f449efb2f377938bae1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6cf6775ff3897572f3e0bbd621234535c7a796c69b1bd863a944e36f8170ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c998c86dd347976c70b62ef1deb5bb319443e099f824b759f9146ef2fc1814c"
    sha256 cellar: :any_skip_relocation, ventura:        "d9c2e26ecff543f3b08b47b3a2eebc028ae5fdac50283f79a50ba182352ae534"
    sha256 cellar: :any_skip_relocation, monterey:       "9080628584c9d409d2aaca7a829254453319f70cf3880c469fe5a64bc8f9000e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6eab4cf18cd9c1f84ff307ab8630b0ab3576ffe9a6d7933f4348d419e9379ce"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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