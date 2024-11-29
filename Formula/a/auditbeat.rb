class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.cobeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.16.1",
      revision: "f17e0828f1de9f1a256d3f520324fa6da53daee5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9964347daffbcbe8d9a41721fad49640e8b2a2e7512efdc60baf1ffc9fb4eee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c0cad143c5f4868dbfca290cc87537a8cb84c1646c421898e2a6ba2e682d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a22b3a830e488a5dc294d18bf03b5b5645f8c4ecdd0a1eb8f9ee74e6802441a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f1f6c680f4d5e3ff1ebf562d4ff026f07683bad61c07cf0a54e9e3a1545d5d"
    sha256 cellar: :any_skip_relocation, ventura:       "37063da62c8839549b1aca28f9872d691c173710090651b7041b6acc2e831dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8dc83a4981735761564f5d4db11209de98b9fca00d581ad0ab8c9f3c77f4fa"
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