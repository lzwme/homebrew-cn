class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.2",
      revision: "b036c1c565cf24c9b720605632234d20cb9dba60"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5d9f272fef76f9743c92f0db3a4e30507a94ab9f50dc44411e71222ba3e0cc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e788b6a7068599801db1271375c5fd9055f6171327a4504c875348ce692d59e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4cfa6addd40fd51bec5c8292a4e2d99b9950e1a4438fd1f87a9cc2750602c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "b934362f65f9900fa6a6d275619d37a94b734e22311373797262ff0523b2ff0c"
    sha256 cellar: :any_skip_relocation, ventura:       "9dc9f0045ba64e0f0e075cb6b82b8202ba7689533526dabc8003411d09978291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c938bfac879f697264d356dded74533422919c84899c4a3da59a8e8aed54b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e337a7c0a1568e476c25439967a7f1d54286fc82561cfc96689ee67e672071e7"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "packetbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", ", includeList, fieldDocs)", ", includeList)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      pkgetc.install Dir["packetbeat.*"], "fields.yml"
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    SH

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