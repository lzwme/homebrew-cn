class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.4",
      revision: "b24ddd14c936c216817afed0cc7d0b23fd920194"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09fd30581c8b391e3e82c9b6d47d062a12c5dcfa0ddc33da2a51064d6dc1ffbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "445d1859f7268b9bc2771e98c1b528828314e22e84af6252c56d2eb2eeabfb91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d704e465600ef669bb099f6f9b249371798692463891dec503dd00e7abb51e82"
    sha256 cellar: :any_skip_relocation, sonoma:         "b10ea228dd7fed5f1e6aaf73e1054ed2feab054757a938e87e606b7874ea0d14"
    sha256 cellar: :any_skip_relocation, ventura:        "c9ff84e21a96a18a08abbde431dd4ab9b416584826166467312d3ba145bbe7ca"
    sha256 cellar: :any_skip_relocation, monterey:       "7a903ef29a72a3cc571edc05231f1e91222fb2a65f7698ade417c49897781cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24d34f114445900afdb7a956c3c428f209159dbc459944ba7fe558e544308dfd"
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