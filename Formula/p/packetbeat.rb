class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.1",
      revision: "19c8672c0a5bf2fb15648c0caf62d985af5a987f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d17f9a02b18f0d60ecc0b4c9f1e58ba60938374585d59559e5fe8bca231d07f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad4d60f48263cdf7281b191890e57e1d42f9563bddc337bbf02750c5635522e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229ff42bf6156c50507ece16744ee7473f1bef03d299f28df8f3d217919f7bc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c619e3815d519c01febd77c790e6fdaa71c60ffd7a1599e27cb1628b2d6028c9"
    sha256 cellar: :any_skip_relocation, ventura:        "e434366e05fd41ef567d956cdb76a1c5722ce4f976633be3dbccb3d3194c4362"
    sha256 cellar: :any_skip_relocation, monterey:       "6be5ad55ddf1350db097ebdefba4948ae3985332d3f6fe46d99c46a17fcba101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27fe13b2d5ab68d6f78706c08c189f56d46aedd151e529e143e54d12a66f7a64"
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