class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.15.3",
      revision: "bbed3ae55602e83f57c62de85b57a3593aa49efa"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf71c056f84059d3f8770a52feb4f8d8b56a8d933c7e713f3e0875e79a7bbd7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93c1be047de0e7921ac73e79344e719a7fa3f8300d99332aadaaf449d250035"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e4227e4e1a59c03c297b3264648d93db6d398acb8aa422529655e131856c7cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "49139426b7e93a007b9d3595270febb7d9e6fe38ca7d4dce7687bb1b5be208e1"
    sha256 cellar: :any_skip_relocation, ventura:       "7b292873c0d7348cce2bcfa3696cae42fa71d865d54808255f84cc6bc70141d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab74b033b8f57c315da79962edb67c41b0535a3831c46d64992826c956808925"
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

    (bin"auditbeat").write <<~EOS
      #!binsh
      exec #{libexec}binauditbeat \
        --path.config #{etc}auditbeat \
        --path.data #{var}libauditbeat \
        --path.home #{prefix} \
        --path.logs #{var}logauditbeat \
        "$@"
    EOS

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
    fork do
      exec bin"auditbeat", "-path.config", testpath"config", "-path.data", testpath"data"
    end
    sleep 5
    touch testpath"filestouch"

    sleep 30

    assert_predicate testpath"databeat.db", :exist?

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"
  end
end