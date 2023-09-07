class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.2",
      revision: "d355dd57fb3accc7a2ae8113c07acb20e5b1d42a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7515ab06f5066f3f2baea192787b93676a5fbda293f3aaf32b506105be81ada1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3f52c7b8f79afba8b23d6c335724e0a398d31f2295a45e832d0f9701a1a0e15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "163c585d354a238c48db4e27f6e4cc7b8bee3036061b76d366f68bae1e6c0739"
    sha256 cellar: :any_skip_relocation, ventura:        "fa723da3ad58781721a8347fe3be5426806310c36f57f24788722559ad83915f"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0fbffbc3cdc850cfff420f70ce5acc27517d3c46a7de8f9c237fa3af03db42"
    sha256 cellar: :any_skip_relocation, big_sur:        "db7d8fa3857cbf3629bf670a1ce184229ff4784ace1e8b0e7798e508fe5105f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a74128af962a02419f914cae0d3fab7a811fbaedc3fccd8cf85c27920543cdb5"
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