class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.1",
      revision: "bda40535cf0743b97017512e6af6d661eeef956e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eae6765c49923b597d607b7fd7b03ef7dc57177285a9ca18e510b2d9d7fbd239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ade9f7f16d0694bf75a275e707adb0eb921d77b83aea18ac29df5ece9289c0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3ce8b1a74af90c122f91a1179370e8e7d00a5128c8a3f91c538a793bfc5e765"
    sha256 cellar: :any_skip_relocation, ventura:        "6bec2f9cb984f487718ac5769f560e2fc37219f8356b7066a40348cda3c4f514"
    sha256 cellar: :any_skip_relocation, monterey:       "7b9827250549b67f5a3b9f750309a532c640bbfff0e14287823c3504c47b56e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ca460b0ff0170f0bae7f477834ef34d6a398f11c3d16942cae7be3eb36ea3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c498c9c067554c86ff0a2385fa7f3e7ddf62be8f2aeae8936e7482dc062637"
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