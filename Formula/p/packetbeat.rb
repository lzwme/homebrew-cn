class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.3",
      revision: "37113021c2d283b4f5a226d81bc77d9af0c8799f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fb22147cf1930ed6df84e30d74514f655bc37073acc5c567362f692731c6666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f1364976326dad6874cfe2d589bf808e06deeb27be72f097b84382d74d48edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb78c0b329f6b3895fadb378223cc38d06cec917337a8349ef09e7a6acc5b575"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b81d5b3ee0650698f80d32e4fd61f4b15c36ef7d34fb119f842a5878a0928c3"
    sha256 cellar: :any_skip_relocation, ventura:        "ac4f245a1779d10c4306c57122e44ae49e379bdcec647f9af73f5e2f2c0c2a3a"
    sha256 cellar: :any_skip_relocation, monterey:       "98dd9645a20e0cdecb8dc541c2fe0d63f18356402d7eac91ad61588cff86bc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be118fdd66306b2c3b7ad7fd12ebb57a30fd6c100a319849c312a09174524917"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS

    chmod 0555, bin/"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end