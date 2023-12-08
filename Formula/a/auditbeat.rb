class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.2",
      revision: "ce367ff5456dd8a1a93d6bae8fd600bb04816718"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d01e677be482d250c46d212a6f3abfa65515f4f411a493092a50f582ca11fe9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0233870331c3e3a254494657303ede402c11a5f2158b1953c51e0e0e11b6216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e403b613ad4103ae9294d9c2d10b5d5a16d564f912edd64139bf22b085380e94"
    sha256 cellar: :any_skip_relocation, sonoma:         "06e61fc1c4a4fe7389653a8c419b17c44fcfa5077d1f30808c53eeb68c47f5bd"
    sha256 cellar: :any_skip_relocation, ventura:        "a783bab7d9a95b6bed9fa4d750f324f6ae6a787dba8789b3a389eeef3784e327"
    sha256 cellar: :any_skip_relocation, monterey:       "b9fce9154273ce6bb6002e57634a5d9af0e37225328042df9cf4484e3127c103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f618b797e02336658c213c3596de58dfe6624a1fe5c355bb6bf7ce234ddb7fb"
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