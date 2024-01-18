class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.coproductsbeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.12.0",
      revision: "27c592782c25906c968a41f0a6d8b1955790c8c5"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd90f6ce852dc9aeb353f444014a1b38bfdfd34c9ffd80efeb9374f2be559d23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627cb899357db6bebe85e2aae202d3bffd31f78d2ecdf04f77b6ef67e73ae3dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ad8d839475dfa3d0b367cb4b6320c15c9ccc7c99e1392a6b5b62cc3e6441fd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "629fddfa5f939a8379e7346bdf26b0d96ca8ff2dbfce060f337c6350d149d775"
    sha256 cellar: :any_skip_relocation, ventura:        "e084095e0af8d04c1fb1b6f8d6f0f4bfb2635de70bc71e38666b20781b1a80cc"
    sha256 cellar: :any_skip_relocation, monterey:       "ad9ba8d3e8ff2ae26fa5859b7a5ecf58c31907441c5e8b8ff4897d8968f0a683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed51b921fb69ae68322e496c89b880e41ede0e5f8a3365fb0687fe1b966d8f23"
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