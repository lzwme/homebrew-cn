class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.2",
      revision: "92c6b2370e46e549acda91b396f665a7e51e249c"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c095bb1a379fb1f6400516d0f3945586d24771d7754ee310fa02e3448ea909b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821e1b301dead0ba713f4e6690b30ca0ab8414affd8df602af142dfe2a2b5531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5105f88557d20319781b3a131c8330985ca150ccf9f5f88bc357e32896e0debc"
    sha256 cellar: :any_skip_relocation, ventura:        "6010d4d4e567fc13fc67acf658c68504ab505c31d07437eb8db5746f05d95f34"
    sha256 cellar: :any_skip_relocation, monterey:       "886ed79d9d821f30a2462ea4d5aaf79870667808ab2677674f17a1d4bb661af2"
    sha256 cellar: :any_skip_relocation, big_sur:        "66422a015601c6195ab758198305161ceebd11703bad2fa17c3e6c16bcc0eed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a3b4910d2b09c3acf45f833dd96c72ab18755b36ac156d215ed2c6ab200b639"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    EOS

    chmod 0555, bin/"auditbeat"
    generate_completions_from_executable(bin/"auditbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  service do
    run opt_bin/"auditbeat"
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end