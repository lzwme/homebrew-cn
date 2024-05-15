class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https:www.elastic.coproductsbeatspacketbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.4",
      revision: "b24ddd14c936c216817afed0cc7d0b23fd920194"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97a52f5d62f60a7d89989cf12551ea49755816915bd22fe329100243676bda93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3779b472fe4cac5216e737653fe97f19ce54b90c3d0972e387082f35b2ea7a3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c8c32e93e79f3e8a9388d9fec2e707e5712c649136d9439a63e95cd2b55ed3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e8477b70f461f2bb140bbd2b3888194d97a614050a8b3dca0700e2440dc4712"
    sha256 cellar: :any_skip_relocation, ventura:        "98b102ffd71aa791943b7b247f99038709c36ebf5799a2607f3cc455cc0a16ab"
    sha256 cellar: :any_skip_relocation, monterey:       "3b3695201c2c3431aa8e9fa3debedff30f9af3498331bbc7eb595a01d768001d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8991305a4687ff7183a56f92576571b7758c1bae9949c61cc2c10967130cc0c9"
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