class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.4",
      revision: "7f7d7133471388154c895cf8fc6b40ae6d6245e2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c742f455eb3eb3bd8987b36d1120f0bd0830415afbbc782553c55bf83eb10578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9ad67c42d227b6eefc10dd24377bf7dc291280979844a878205439309659a13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce86bf970b8b919e0ccf98300535bf41eec260c1545601624a2e5b58d5ada631"
    sha256 cellar: :any_skip_relocation, sonoma:        "871b93127d99aa3b163038f659de68dcac5287a651269927d9ec9620105f6a76"
    sha256 cellar: :any_skip_relocation, ventura:       "0302ce1f2026fa8b28b056be065891cd74ed3a7bc813afb642c8e45233587ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae962aa10a15286ec00433dc2482a3e78f4a9570054629f803e2735e3dca5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86590a132d89569f5821c5c2aa2e1da00b7ffe36d71f000328d973dd4eeb060e"
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