class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.2",
      revision: "e9455e203842edf9086f34b3ca2fa2b08bc76081"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4ea500aa747055488d4a498671e9a3479c0c1a03c09c75cf79915a8fa8ade21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "998782a4dd1ba51f0fd817b9e07f655dd05f8276d379e57ac8d4233ad7838beb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac2ac5a4ad9cb1079e940b66bfd1140fc2df916edd8d3e6863c27ed437733035"
    sha256 cellar: :any_skip_relocation, sonoma:         "25ac6568acf448c3436e889ba8f0e49b11135f41695373b482609fe4d176348e"
    sha256 cellar: :any_skip_relocation, ventura:        "168bb658e20162cf9f76d9e18407c881a078429d193ae1d6c60e38a4e0f8c542"
    sha256 cellar: :any_skip_relocation, monterey:       "c500697291bef50aaf728ca401b3cffbfb6e48de00fd433fb5bfd20a325473b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a09be5b5aa80abc66363cbd990b26acbd8d4a91556eaf173a3572c7ddc075f"
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