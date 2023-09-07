class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.2",
      revision: "d355dd57fb3accc7a2ae8113c07acb20e5b1d42a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0df730eb321cefbbfff7cfe1fcb7acd01e08381c4d03c4693e81250f9f5390bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e9cd6aff523aa28d41424952cab79d2d428824f34f329708910f9cdfdfd82a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7610c70d98e3ddb89238d6ec97d5a2ddfd0c49cdc3389dfa9bdd0cd685478bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "d44fcd1435052faf0bcd1aceb4fe1786b0dba701397b6e5c75db3905c6fc57f7"
    sha256 cellar: :any_skip_relocation, monterey:       "1740afafd10944cddb607195af97bfaf29377d77786d59299dcfc0830a4990e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c339b859c5cf64e1aaa13232a0a984e9651259585971b87587e167d5d4016a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d581d4a96d6f627a08aaaf699689cee659ac44f6924968853e0555560c92bae"
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