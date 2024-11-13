class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.0",
      revision: "dd6212261c57e41e1bf42532809a14a00c9072a9"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdbdfb6fb333df7747eae0a5e6838918617e6670fa369922f61e6d720ab15eeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c1108e011b202b3cf8a212d3e99c47642b6fa0a27b80c1e92c009bcfd90460"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46824ee757eb5f36843496e6acbc2027f43260fd299e7d6b30c551b1bc4d3afc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c28742d527511f20bb76b432b78ab1cdb0426568083bd3f830a4fc42efc3ae28"
    sha256 cellar: :any_skip_relocation, ventura:       "9ebba9420d1722dca4d0af670b9e3530b04e6773179d00c2d4d31535eba3a3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ffe3ae248dac5176868a517fc1e961878e55758dfb90debae41d5f5a41e1aa"
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