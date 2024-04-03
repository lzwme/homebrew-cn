class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.1",
      revision: "e9e462d71bdcd33a84d7f51753a116b5d418938f"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d7908ba66e09c71d1c28262bd2d44bdd306c8f96e4088a2a7495e0bde504e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4792a8e62827adcc132b0407b06cf3bb658396a63ad361fe0fc9481e7a1abb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20186fbc6e44928468d011b3e61448ee2036d64c7afc592415e6340d984ff1d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ca313d388f86a7290aab5a0af1bc3f509d02f25cf1143983a1feb1d50fa9163"
    sha256 cellar: :any_skip_relocation, ventura:        "a3e5d6a82848e814532f007b9b8884a442c72b043111c86e69f5100ac0336dfb"
    sha256 cellar: :any_skip_relocation, monterey:       "a0e28cfbee3614da65ea937db39f5d2871b0ce82ea0443630a12ac67bdc6a293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6791df00b3c1269becf451151ac77550c92400fef64121dd52110253ec138ca0"
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