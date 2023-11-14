class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.1",
      revision: "19c8672c0a5bf2fb15648c0caf62d985af5a987f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d94f1823005944caaf899213623398e9d510a72e9a35a5741908a95510ffb038"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ec76144fb29bd0a5e1ea927599320042511d1efe8037c3479512044e2c40b2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d36cc61adbfae03347b6c6474d5615f25f8caa70e505fc6f4c845042e166fb4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d9ff302225dad6c6366f26a11e0a0f5fe207f6f5a499698c21af31eaa543e14"
    sha256 cellar: :any_skip_relocation, ventura:        "8d21a8e344898fb2aec273ef75bc37368862358d486dfc6c5a3690343f4cfc4b"
    sha256 cellar: :any_skip_relocation, monterey:       "b5541d15412d55f90c378f1888f05b3a448dc82564b2a50f3664ef690ebeddee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b14200b317ba56e6521bb61f08c30fc5e22f4725a9c1275f285c9617d0349e"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

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