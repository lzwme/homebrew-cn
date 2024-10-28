class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.3",
      revision: "bbed3ae55602e83f57c62de85b57a3593aa49efa"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7d472c0e73609ad7bed462c652088f7ee492c3eaf5029cdb7909653d13b0cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56fd819792d4f64a4049144be89fca7fa63535f19239f34d77f3552cbc3e18da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b7dad02f21424134b42b75732d3ef2e613aa8895501b3b6a20e7de6a62e02df"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbaf7b1d6769f6436eb117c58947d6c2349e21c52cd8fd59d421343a18955912"
    sha256 cellar: :any_skip_relocation, ventura:       "7ec2ca9d581398353beacf33ec656d94f91e4237499e369dd74e57311772c831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80e5fd75df5d3fc534b052f6e25b6d6605e4df33079621835e917c6db40c5807"
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