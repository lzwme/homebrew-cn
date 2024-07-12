class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.3",
      revision: "71819961045386b23edc18455f1b54764292816c"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46c3724189389a14414db6e394704659ffe2383b37af7aab43c7bb173b573bfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a79f6451b83aa52458c1e178fc6bec93dd0888d38a74ecf27cd408871ffdbcc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8198f7de80d954247b01d4274549531a6519f0904f06c8d1b0cb80d404239188"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b0f5788e8778769f92ba20612edb3f52aba2f1e45de4af346dd1d409e368624"
    sha256 cellar: :any_skip_relocation, ventura:        "04f62174b74b38e8125b4436f2f094f23b3bbf4d1ea6697537c8a7a4c98b7ded"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e70e29c8f110b002ccf3ea75340dd67527af5f1f5c11d47d92dcc715c8c9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c3ec499229c88e96731af98a60087fac23410ce52cfb4305c4b23687f8fb5ea"
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