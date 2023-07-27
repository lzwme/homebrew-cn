class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.0",
      revision: "dd50d49baeb99e0d21a31adb621908a7f0091046"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f45c412d3f5d336dca85ff11ee6f4a55834791183c6fdb43136bb8bee9dc1f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e93afa18c76786ebe63f0ee085f29bbaca9bd2edc50047940cad05e874a6ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a347751bba84d6bad2a6c5a80bd49aeaa582f151bec3be89fdcd11651fede7ed"
    sha256 cellar: :any_skip_relocation, ventura:        "290b284ff96d7a77f19b47e602a95e5bddf5ca4522e6f70ae77528b6922ae170"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d1c5bf3ff54a1160ff6a1090cc0e0431dd09ed35c33ccf24064e2be9271457"
    sha256 cellar: :any_skip_relocation, big_sur:        "1463e906f419370415645f3a5ab7fb1a48cbe3ca8c21e5d99351e65f1599f419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "009abeefd0acceb311097d40030c896567bd8be35021b0d06f26df6488e7ae91"
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