class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.2",
      revision: "d355dd57fb3accc7a2ae8113c07acb20e5b1d42a"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1335b15b32727eaed6e4e9ec30121f0b0fd02d8772ee4e6f10035931a2ee51a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff1bad000d1ae6df5c37a143bac1101a4803bd95f9356fbe831c8cdc85f8b7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f3eeadc5b25859e7a4cdfd2fa52c6bf747c7cc821a5b051779b768cdb50b166"
    sha256 cellar: :any_skip_relocation, ventura:        "9240eb4cd6972779a805ee24fced51b9141d8e91b64b7445e56beca9af0538a2"
    sha256 cellar: :any_skip_relocation, monterey:       "ea38f18e11d88f80702ce6512bbd3e06e199f5f662859d00175afacfa23b47ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "cae4fd9e7afbda927068b52bd68a40d0df92dbd9e565951c0db55bfc12a31342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffef6089120fe326295f85ca992184b995a61f57885e352fc72f3c9e5c2c88f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, includeList, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, includeList,"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc/"filebeat"/"module").install Dir["build/package/modules/*"]
      (libexec/"bin").install "filebeat"
      prefix.install "build/kibana"
    end

    (bin/"filebeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/filebeat \
        --path.config #{etc}/filebeat \
        --path.data #{var}/lib/filebeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/filebeat \
        "$@"
    EOS

    chmod 0555, bin/"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"filebeat"
  end

  test do
    log_file = testpath/"test.log"
    touch log_file

    (testpath/"filebeat.yml").write <<~EOS
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

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    fork do
      exec "#{bin}/filebeat", "-c", "#{testpath}/filebeat.yml",
           "-path.config", "#{testpath}/filebeat",
           "-path.home=#{testpath}",
           "-path.logs", "#{testpath}/log",
           "-path.data", testpath
    end

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_predicate testpath/"meta.json", :exist?
    assert_predicate testpath/"registry/filebeat", :exist?
  end
end