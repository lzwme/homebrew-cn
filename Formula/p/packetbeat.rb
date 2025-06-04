class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v9.0.2",
      revision: "26ce6f2d4c4de66c3b73a1acf3d1be01b817d791"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506799b9cacf8bb24e94b54ad9ff191b2f1f388303961c0ee781295a2b1b5188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cc2d3d0e55e3a4847a68e0f88dd9932306bf3fd62d0ca9045bf7d489abdc3ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f54dd6a6fa8a78047d3ba9e8777d311917c384fb6f3e442771dd567c8f1c8179"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ebf893b95059665bf36087b083e3a813f9f344a265f08637f379b5826a5113"
    sha256 cellar: :any_skip_relocation, ventura:       "34f50a8783523f9f8ea61a6dce204f5f283e30cd3054aff664d2b16754df72a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bcd85648ef10a41233cedebddd96dac29ae06664e496c0a14bc61109274363c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24513ce6458f2e7fff59462f35fa4182ac7693c358ba909c2c5a5c2d8bfbb416"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docstests
    rm buildpath.glob("**requirements.txt")

    cd "packetbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", ", includeList, fieldDocs)", ", includeList)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      pkgetc.install Dir["packetbeat.*"], "fields.yml"
      (libexec"bin").install "packetbeat"
      prefix.install "_metakibana"
    end

    (bin"packetbeat").write <<~SH
      #!binsh
      exec #{libexec}binpacketbeat \
        --path.config #{etc}packetbeat \
        --path.data #{var}libpacketbeat \
        --path.home #{prefix} \
        --path.logs #{var}logpacketbeat \
        "$@"
    SH

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