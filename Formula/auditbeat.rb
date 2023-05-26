class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.0",
      revision: "ae3e3f9194a937d20197a7be5d3cbbacaceeb9cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d4754bcb44ab6dd1d9af90391936a8d06011d02485d81b0eacde66d49bc11f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b2bda42fa1213c7ff3204976297d839ed0acdd79b06bd5e52e44f0e678f8f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b92a5a2793bdc0745d7fbc44a206a99ac6655f560e20f8b2fd4d0d0179b12eca"
    sha256 cellar: :any_skip_relocation, ventura:        "ad18add3f80e280196278832e695a89652d98560bd29a779f9c15fd13b1245ee"
    sha256 cellar: :any_skip_relocation, monterey:       "a74db53dbf11a9dfcf9d8f065df103d486de3e9346385ae7b3eea9b8f09a8ec2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6c4504e6f6e864f6bc390270ed7c262715ca69ccbcce3d08f1c12f621739f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e7d6c5e075cf9a105e18a68498a0463f5c976ad333cd62877993fda7d161ef"
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