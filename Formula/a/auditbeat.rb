class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.cobeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.17.0",
      revision: "092f0eae4d0d343cc3a142f671c2a0428df67840"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629e80dc0ecdab2029aa924feda7dafd9e7962980851f7a98c8e358ce0dca89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9999e1844efd8399bdb6b04fa431dcb3f67a0027adbc7b37a34eb20e9f5973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2693ffb263f4a65ff3e2c52c694bdefad4fcd01c1bc9d6b49c642a5c01ed6893"
    sha256 cellar: :any_skip_relocation, sonoma:        "42387fe099ef0b6dd232aad224487ebd74f70418db89149c763cc41953e39510"
    sha256 cellar: :any_skip_relocation, ventura:       "1a3e0916daa45a5839bcbab0b91f6687894b4dd6ee858c091cbacaafe15fa402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0406a989ea15c8fd446eb1c8419cca5d712866dae4374cd57f337dd337643d85"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.12" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc"auditbeat").install Dir["auditbeat.*", "fields.yml"]
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

    assert_predicate testpath"databeat.db", :exist?

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end