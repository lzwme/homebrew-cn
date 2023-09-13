class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.0",
      revision: "62873ab51c9cb5492f3f2b1ec597396071564737"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec562585c75566195ee3d512de74efcacbf03b597533e2b70ce297585bd91a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a9c98a0f3e858480cc770f8ca3a012d4d4ea984815410ce3c5f51761f81e68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a041f4df05469e5d248c4f7dbf36c19b17db0fa4fea013934adf021a95fffa"
    sha256 cellar: :any_skip_relocation, ventura:        "02cc1a33945464307bcc166960790faed0105c06a9ee9c575af7a7eabd42286f"
    sha256 cellar: :any_skip_relocation, monterey:       "01f2ff1c6b5959aef2df349aeb9fdd15167acca8ad86fac5d20a5a181029db3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "45557e85919f876cf5a54517c1dd0be5d28eec653f05d011f6801d206550718a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8508d8a375a9542bda4b7a8ba70be220a2c041d1107105f86e67c255f110e720"
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