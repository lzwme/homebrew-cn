class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.14.2",
      revision: "e9455e203842edf9086f34b3ca2fa2b08bc76081"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56b0ad9717f2e15478dbe39c24e52ea24cf5e780e6fab4faf5d5672bb40dce97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e14ce85b606fffb4cb4d9de6b03eda6674c240c2c73a148efcd2ddbd8cf203a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c4b5788a9a3b3181d4fdce82da7dccc1f732e3dcbeaff553f51c88d98ff6e28"
    sha256 cellar: :any_skip_relocation, sonoma:         "81bb6579cdd6ca4cba98c49ef2dc8a5598c623a9eefc70180d6defed2c640bcd"
    sha256 cellar: :any_skip_relocation, ventura:        "822f600ad6a70ccf40f5e5b1ee1008812a1e0d2f5f0962b3e01994942f0835a7"
    sha256 cellar: :any_skip_relocation, monterey:       "7ab4f52d375a9fd9e456ad7aa6a395757525ffa894e024e7dadb1f0555e78bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13b281e1ddd4d714342e073f81fa688d7e7a2a2cbb00f723a86b1023d3b2d02"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec"bin").install "auditbeat"
      prefix.install "buildkibana"
    end

    (bin"auditbeat").write <<~EOS
      #!binsh
      exec #{libexec}binauditbeat \
        --path.config #{etc}auditbeat \
        --path.data #{var}libauditbeat \
        --path.home #{prefix} \
        --path.logs #{var}logauditbeat \
        "$@"
    EOS

    chmod 0555, bin"auditbeat"
    generate_completions_from_executable(bin"auditbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var"libauditbeat").mkpath
    (var"logauditbeat").mkpath
  end

  service do
    run opt_bin"auditbeat"
  end

  test do
    (testpath"files").mkpath
    (testpath"configauditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}files
      output.file:
        path: "#{testpath}auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}auditbeat", "-path.config", testpath"config", "-path.data", testpath"data"
    end
    sleep 5
    touch testpath"filestouch"

    sleep 30

    assert_predicate testpath"databeat.db", :exist?

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"
  end
end