class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.4",
      revision: "4ce96ccbcbdd9b4f149e1af9ff2a48af7f42ade8"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f164a06e30556a12661e82ef14523965476e808b3063f55d17c5e67b4b3c693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead80e62eb369a8bd8a98e238d3b50e88aad99bc5b41c2aa0e83425a3b134127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abcda9f5dd8cd746ffba423327ccb0e10a2d07410dcd33c9bf4d6a54352d4e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b38ffd824c67e278eb248c9e37e255f831cd45269617cdece4380f1bab040b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964794c873c1dcc04cf1d90f066c48bb512f3744bc0d5ab18cc4ea627b6358e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4365cc635ce44dc1ec06299b5bd9212f5dbce8804f572aacd2dc63a9ed87d15"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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