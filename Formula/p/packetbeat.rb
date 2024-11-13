class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.0",
      revision: "dd6212261c57e41e1bf42532809a14a00c9072a9"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48db2d572c8d99691fe5cb4e1ef47ddff83e8bbfed1ab5dd997a27b05949d283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ac711fc3f613188866a823c633d7ddc113f1ffdd0445a7ce7f61849bcfc76ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d067c8bd77de4de6c179b45fabdb5bed6955b1c4f26633f90ed0a4584820013a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f0b2af60354003ae080cc7f63dd7b7302d3699913fd026693969500b0cc8ec3"
    sha256 cellar: :any_skip_relocation, ventura:       "eb3983e9bf605ac2e16c06a99edc4baae56be11c0c93067dbab3a9b8be4284a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42046149f9afb07c77972bd6f010f75a013dab388248187f99d3448338419fe3"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec"bin").install "packetbeat"
      prefix.install "_metakibana"
    end

    (bin"packetbeat").write <<~EOS
      #!binsh
      exec #{libexec}binpacketbeat \
        --path.config #{etc}packetbeat \
        --path.data #{var}libpacketbeat \
        --path.home #{prefix} \
        --path.logs #{var}logpacketbeat \
        "$@"
    EOS

    chmod 0555, bin"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}packetbeat version")
  end
end