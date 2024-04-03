class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.1",
      revision: "e9e462d71bdcd33a84d7f51753a116b5d418938f"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c20e727ab79ee0673a9b11575b5691516eced4f10f6ec353dee4b93a956be86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97c8b425361bca8f7c87b075b385748c03724a25f03e3653e41eb1cf8d5ddb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a932ec8fbd39b0bad042b3fa56c1da199dd527cb6019ad43c0ec885530ebfe6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a75b1f4e5d95545aa025b940a2af7b913e94905bbcb72a0133668d23f84727ed"
    sha256 cellar: :any_skip_relocation, ventura:        "0289097d833f906d06b0c723afd4c914b83799a615341833cb086d3ebf3acd41"
    sha256 cellar: :any_skip_relocation, monterey:       "be11b6bd4c73728d0d5f2bab53bb78d013bcdb0fb2f8227ac1f2751d48382b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818bb4940daa39124cc886206e1efa94f9eec63e30d0f6d96478a426a661bab6"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

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
    (testpath"configauditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}files
      output.file:
        path: "#{testpath}auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}auditbeat", "-path.config", testpath"config", "-path.data", testpath"data"
    end
    sleep 5
    touch testpath"filestouch"

    sleep 30

    assert_predicate testpath"databeat.db", :exist?

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"
  end
end