class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.1",
      revision: "88cc526a2d3e52dcbfa52c9dd25eb09ed95470e4"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1e59ce6b0923e2866fc48eec27375d82baa201c39eaaff6661358e09f40c793f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc93ce3e44e5a2ff800d14dedc25d69bb124c361cd0d34a0d4426f5ee6da0465"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6237ad3de4705996a2b15ed4010db5352ca68f6e5fe4c209301107ed0f2c8994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c30443f50c806152be3b078b1204478a3c41d05094fad37033167a2ecb181e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "447011f9f68e142164f09fb7381dea1d37c8f4bcc12fe6818af82135b50fea40"
    sha256 cellar: :any_skip_relocation, ventura:        "4545b4a54b1c4ebcf7a439c70b1ccb8aef08d0aa5618a8360913ad68a4a3e286"
    sha256 cellar: :any_skip_relocation, monterey:       "639547540dfbc660dc9268a6c4dbff992defc9eee201153f441b63b14dcfcd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3147fc3131d138f939fc7e19b232ba7ba9dca6c484c623a6576868dde014d3c"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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