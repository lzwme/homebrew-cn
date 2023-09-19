class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.1",
      revision: "ba6a0bcef9ec28790a10888070eab35b95277e38"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdd4fe44744ecaa38bfd51ee47d17649d11665315e56ca17b77bb4927dd22553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90171f743c7ec370700591e3359416a417dc1eb000fa19bbf692876cab8182ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa18c2e152b950721748c810e79b038149b9049601a1d9d4a52074ecb0b27c38"
    sha256 cellar: :any_skip_relocation, ventura:        "c2b89f7f524691793cd5a39487a435e796a300c0f5e0bf8b2b9efc6913ec3715"
    sha256 cellar: :any_skip_relocation, monterey:       "481e7d03bb5ff558183c87cd0c93c73814e2f7f4f6c0b37d644142b97c37be6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3a98c93cfcf42ce7061f265dab8a97c1b7c94a71434e1dc07c491c23c6c4e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a5766252eb11609882b8e843f92383bf63c6011f0cd63f9c3e3aaa7a6ce0981"
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