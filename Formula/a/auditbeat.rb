class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.1",
      revision: "1292cd58f48325c041317d9a8bc1f1875bc6cf5f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0680baa0a1c316616fc853ffaa593adb2d6e0c46c90b33d0e63f588c593f3ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2807b534169de4848d2accdc69c3ab3ac022665ed723b1a6f70508fd3a54b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7a53e220a478990a96e461007135ffcc42e82f3175c5e4e28c0a8824548eab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3930560d249ae1c6bb8752a5948acd9d4b857bd510450c8eb224bfb660fde5e9"
    sha256 cellar: :any_skip_relocation, ventura:       "4c304cf5f56fc4583f125a8feea066b7c2510564744f952b0088fab724c062d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1abba514c0cc534f91657e85d4d96f3ea2a8009919776d114c0f6c35fe72c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d78999cf2da4b1f4e4c5095d94c517a320e0646b753ac61ea10b9279b9d3e50"
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