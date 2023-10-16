class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.3",
      revision: "37113021c2d283b4f5a226d81bc77d9af0c8799f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7bb0c945f36df078e0807fa9f187a2c3f5b68ba8ed9d35b7aca6d501987fcb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0808f68c2d2353656cf6bce8bc7913a826853de8e6ef81be5e48d80b1635c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f27a9e733c0b9765d8dd4ef5b463325c319887bf3c1d1d569c1368eb752216"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea0fee481ee790534b2b598be9df68078909c3d2186b7623bd07c25799429c08"
    sha256 cellar: :any_skip_relocation, ventura:        "05a65bf15796461f2416908b9ee36017e9283a5972c200fb45fe44ec159e359d"
    sha256 cellar: :any_skip_relocation, monterey:       "64c0affc7ef5d5f40c7d2ca06cdcd22accc6a72731b6013935a803f7e7a20fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d2573b1dabcf4f13ecff3691af91a013545ca8f370801f9c17c70d85184417"
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