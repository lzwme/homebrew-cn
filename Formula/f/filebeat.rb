class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.0",
      revision: "62873ab51c9cb5492f3f2b1ec597396071564737"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ed67baf1ee50402a71f6e5808a8b85ac2b1991396158490daccdadb93840d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a7c32ee58734f4602b8d390f48ba27ee8e9895c8d01dcff408f98e6db35f1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab4f0d5ed90e4cda52602ec309bcf0fa3630f3f4658e0cf050cb3dbefb69a9d2"
    sha256 cellar: :any_skip_relocation, ventura:        "4ddde2e2c27013006645d2c534bd11c0cfad1650edca3261bf58f73c609197f5"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce06bd85eb6d04a6c427aaf76ab02d9a473fd17648abd74deb7699e59ca0f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "3da90325b262c132e2f84ac564c83e16fb631c8e587e4a8c5e5a6da160bf120b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54eed78eab10d065756051e913aa40ab6b1a6fcad749af5c3ae38e6ea2f4a1a"
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