class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.0",
      revision: "d3facc808d2ba293a42b2ad3fc8e21b66c5f2a7f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f9cccecb48218c5fea420b586c751ab8307cb639f47f164f0bcb2b372635f89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "880990ff3165a4637ba93f118e2287e656f0d8d1e50a7af82a7770508805c131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2f6d4ebbd805bc1bf525b49ef3ffe1ffbaa04ee91f51981a71bee7d4938899c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f73bed9bf0735ba24ffe3a9f187d4a43d31071a3f60e12070aa344463f57aa9"
    sha256 cellar: :any_skip_relocation, ventura:        "b4f1205e2aace435d6ec20ceab2811f90287fc42f452a65d82beb502e9e4f2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "fdf75e321073640edcdea8c79bd8d6cdb83274cf3e79c24092f715e334a6237f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edbc1632f9e00a681ea79faf0512f27307ffe11837b8667712955e9d3c65a7ad"
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