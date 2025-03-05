class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.cobeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.17.3",
      revision: "3747d0eb6c26247477dd62ca51535cff8d6338b7"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95c9516cf6f43c194563b01c679a5b8913655b87838407b83955cb6973dafb37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9136501c0e3c2d5f48a6cd60329c7dccb8490cda8c884df275e2858d3a60041f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a261f175aff33134fbafa6fa0e3d8557b23b57401a27926706445abd7c210973"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f27be1c9580f13e88af6bc5c1870fb9bdd7f6023baebd0abdb36b2bda29023d"
    sha256 cellar: :any_skip_relocation, ventura:       "c60387add90667a03cab9ac42ddf1d7145c8b930514186e539153217b30b1a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d4472bb97a2237f53c719dbbc5eacff699c245eafccd8292c312fc2c8a7b1b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec"bin").install "auditbeat"
      prefix.install "buildkibana"
    end

    (bin"auditbeat").write <<~SHELL
      #!binsh
      exec #{libexec}binauditbeat \
        --path.config #{etc}auditbeat \
        --path.data #{var}libauditbeat \
        --path.home #{prefix} \
        --path.logs #{var}logauditbeat \
        "$@"
    SHELL

    chmod 0555, bin"auditbeat"
    generate_completions_from_executable(bin"auditbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var"libauditbeat").mkpath
    (var"logauditbeat").mkpath
  end

  service do
    run opt_bin"auditbeat"
  end

  test do
    (testpath"files").mkpath
    (testpath"configauditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}files
      output.file:
        path: "#{testpath}auditbeat"
        filename: auditbeat
    YAML

    pid = spawn bin"auditbeat", "--path.config", testpath"config", "--path.data", testpath"data"
    sleep 5
    touch testpath"filestouch"
    sleep 10
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath"databeat.db"

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end