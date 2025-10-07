class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.5",
      revision: "49b225eb6f526f48c9a77f583b772ef97d90b387"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79ffd63052a215c3e4a4478fb90d6b2eebfe6ebe94948fc21d74248b83cbec81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ff242e816a19bfbff00c6d91dcca08613b1ccef5914a8fab6b7e1da3a24917b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ebe979b0ba9936928f0040302156a99264c50d27a1deb73992364059a94a1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e07593e7bada95f1f6174af1cb4f00dd4ed9bbcee6619e954b4ae4a9a2bcea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2721b19b6ed6d70341c949111626cbeb9fce47c64b36073115ff6513fcd98a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d540e66fa002a201f8e33d1c6d32c92ba69fa268137f037fa9a5ad9c9c2139"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~SHELL
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    SHELL

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
    (testpath/"config/auditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    YAML

    pid = spawn bin/"auditbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
    sleep 5
    touch testpath/"files/touch"
    sleep 10
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"data/beat.db"

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end