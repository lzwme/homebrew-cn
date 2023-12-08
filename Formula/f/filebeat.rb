class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.2",
      revision: "ce367ff5456dd8a1a93d6bae8fd600bb04816718"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c9defa1567985c84b9613d818a8d4a864a0fd474fb5c362dcbc315def557976"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebf99b6cb7c7bee40335ac36d23e5127a1673a1fce0278d6bbeecfd9cb39d5d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3627170109132bac2006812eb3095d97d2f3be88a0a6e6588991b5cee598d2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "527708b1729cfc892dd4d3082074853b8acbaac1d546f1f2b69d25b34de5298a"
    sha256 cellar: :any_skip_relocation, ventura:        "9b0f62972287a1f0859ea724b0e3692c81bdceddb507877969e3654a0fb3809b"
    sha256 cellar: :any_skip_relocation, monterey:       "608d523fe90e22da19c3ceb178e4b089b6f67925500f3706bb4fba12fc123c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c80fcede13719757d7df2199dda292fdb49ce9a1a915117712d4b078c8f2e0ca"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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