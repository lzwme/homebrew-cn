class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.11.4",
      revision: "61337102fc51ca447027380b50596966ba88b82b"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e838ef3bf4c8af2e81c0b6a38c45dc4ae3695a167a80eb667d2c4eb249c79c35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24197f24e5b613fcc74be0862f1f2107acf7cd4f008a96bdcbb6ec0fefe5ad36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1cc5bb7e6e820b5b477e344c4cfd5af78939e56326a27f0258df4c27c245d79"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bb20a5090691c5c1e278ccbc0d97e66b7b9937366552d8e8b32284b699b7653"
    sha256 cellar: :any_skip_relocation, ventura:        "52fb61ea4e591c933c20d13d594b7b6f0c4144f6b736a18a1619ad39986d6b68"
    sha256 cellar: :any_skip_relocation, monterey:       "0010bac2a45e379afc16731d9782d922d7f51315d3df853bf76398a45ac7453b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f314924b54a536f8109407ffbfb8a73e9cdb01e60fcb7cff8f2da2083b5789"
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