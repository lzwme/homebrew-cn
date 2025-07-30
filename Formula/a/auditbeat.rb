class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.0",
      revision: "c53b4a051bee29d3e5b3cda16753ea18d47e339e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02f49cf87ca4ec610e74c0d607f07d60fc722cbe42772ecdaeb0466c678a51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d8e3a7efc7d53eccc3d38fa0ead7ddf93bca9195875b6b96e73b9af106c5d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a706ba96e811b9e8ff864eae28b0105f476131c5308f0234fb472ebc0f7ea5af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e453c169b6adcd8c34b05a08cba047e4b6046f17c7ba8034d71b6cd58ae06943"
    sha256 cellar: :any_skip_relocation, ventura:       "23e7a80c36096de0cd652e8d1f51064eab03c23a6215b44da8e736095b399028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f2ea067e1020a60f95128dcbb2fe4582dafdfbb6226a1877a5674c7e4cb5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2661cbba90cee3be44a4084c9954c9bdf1b8a65fa1c4ad9e9f622a42c6f338b3"
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