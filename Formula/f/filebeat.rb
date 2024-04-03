class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.13.1",
      revision: "e9e462d71bdcd33a84d7f51753a116b5d418938f"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ca72b76eadf4bea30fd8e807488d1a7f296f3f8c658475eb60296cf395beb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec6ede0fcb4a11a31fa8ea1c41a27a3c0b5cf236f89b70aaec4cb4d3b6ae5e2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e180a1bc6a9b5131a6c745324db216fa58174cbb314cc07d4f1dac6c66f1e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d781715f58377d13ed8524c696d6823660da856566ac89f09829e3bccd2d33d"
    sha256 cellar: :any_skip_relocation, ventura:        "844eabbc7c05c22590782fa82d1e30f6e5d1b97ab1d297a9bb2a02042845b189"
    sha256 cellar: :any_skip_relocation, monterey:       "969f564f21ac5361f5e5253680277cf7bceb50f873544effe4dfa35a75b9bc74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc247e49152ae3b64215054d1a2d4795fdbe88446c8bb9795ed02dc89ae205e0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, includeList, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, includeList,"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc"filebeat""module").install Dir["buildpackagemodules*"]
      (libexec"bin").install "filebeat"
      prefix.install "buildkibana"
    end

    (bin"filebeat").write <<~EOS
      #!binsh
      exec #{libexec}binfilebeat \
        --path.config #{etc}filebeat \
        --path.data #{var}libfilebeat \
        --path.home #{prefix} \
        --path.logs #{var}logfilebeat \
        "$@"
    EOS

    chmod 0555, bin"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin"filebeat"
  end

  test do
    log_file = testpath"test.log"
    touch log_file

    (testpath"filebeat.yml").write <<~EOS
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    EOS

    (testpath"log").mkpath
    (testpath"data").mkpath

    fork do
      exec "#{bin}filebeat", "-c", "#{testpath}filebeat.yml",
           "-path.config", "#{testpath}filebeat",
           "-path.home=#{testpath}",
           "-path.logs", "#{testpath}log",
           "-path.data", testpath
    end

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_predicate testpath"meta.json", :exist?
    assert_predicate testpath"registryfilebeat", :exist?
  end
end