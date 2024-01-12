class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.11.4",
      revision: "61337102fc51ca447027380b50596966ba88b82b"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5801c904b7778d979e3ecf2050ee4a4cf03184d1198fe9e2a455c2560b2838ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "872b48ec45279e0efa109b5f37066a691e666601dccf78b70b56eb3f9f916f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dede3d497c27029b3d1f1504b4fe51165ff3b77bae80e7bfcded5c7bdd397a3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "df1ff6c14698188076d6682a79138a3280a4894a9bb3c3b19f6d4617e42c7c15"
    sha256 cellar: :any_skip_relocation, ventura:        "b55e78c48258364bc13f8b3cc18fd89b024fd04d406a983ffbbe718ccd260a66"
    sha256 cellar: :any_skip_relocation, monterey:       "2eec5b0ac5ed61fedd368e711344003a2be53a8b83cfba23ae9cce5a5ac0c518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3daac3041076c76f803a692e7adf18c30e08666f74a0ddea5fc7cc32e527cb93"
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