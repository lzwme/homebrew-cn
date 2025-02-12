class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.17.2",
      revision: "cf5c18e080581711e9189290187fbd721e962fac"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6987d29cd77058550fa2d520edf11cefcd8df175fed049bb65163599c8f7897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b94246837520145710585ec77b2b8121a93f43748e6a4c448b77c7c48d99786"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c150c09f49c1791c4b208ba8ed30e633bcd4a583e6609ae7472fb440c3940ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b77f9b26e0cd10a6f5bf5eb394ef9a212c65e113f0b0fcef39fa27b6f91d8ea3"
    sha256 cellar: :any_skip_relocation, ventura:       "c2e9e6469f2e8281fcc8f29977a8be2bb33735cd13619102badb82b8d8e073cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f4286eda86cd88594ffe90124fb7b1e8a8f36459720055a95bb5e725748d4d1"
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