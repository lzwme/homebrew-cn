class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.0",
      revision: "dd50d49baeb99e0d21a31adb621908a7f0091046"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "308911271f166e95bb9a7837cf7532eafb40ab452c8651f57aad35d41dc3492e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c8c5ee0775a7c0dea315fd684c8b1858f5e9037414620ab22b168c21be4836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db4c50768ae561e87e8bb85fb1b16fc843f1496f495f555f8d2a136f81b3fbd4"
    sha256 cellar: :any_skip_relocation, ventura:        "d7b771573ed3aa2ca6a46471723e6475cff0b78e5cb3859d3aba96221b0a9a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "bdbfbc3cee2ccd94cf5e1fda44ab79857cdde4b2ed2b902b18cd507176f7a7c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbebff0501d1989f21e2693958497e2f481e891f39bd39d3d3c3a4804d7f9068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "383e5504ae789dbf04cdd932da17eb92ebb6e3ae31431d2d26e98bb6fcbdaf43"
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