class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.2",
      revision: "b036c1c565cf24c9b720605632234d20cb9dba60"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f84e8c2b3e51dd509d309f61a4e03a51f4038de1638a7aafab0f8bf7b627fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f9cc155f01c0f55e3b8b9aadc7a7eb6ebb00a9e17120a2cc077ee00291136ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3a43c28be86ccc5f7a1b85f421e16cbe34cf7858ad928c141d0b3f62c50d5d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6631c0be209b78105da0acf78cba2b4fb13e36be6a0c532551ca4767c1b29f9"
    sha256 cellar: :any_skip_relocation, ventura:       "4436332844fb095b1e296200dbe35eecd4051eab0f5707ba81dbbae5082a0aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a785821e4b393f591316f916208e27f083f99f7de5cc4a924ce6f453bf45c261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9daca552939c44c8cf103fe57ef137c04aa889b9d236b54f21c2a3e222445827"
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