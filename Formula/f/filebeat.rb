class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.3",
      revision: "37113021c2d283b4f5a226d81bc77d9af0c8799f"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0df7f68d1c55eb3dc492826a06044be9f77cb49a6db43f48632ba582503d4172"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c9fe3f333594a944e1a0e82bd51cf28d61d337c6c89d4ac834b4ff56da6435"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc6f528d3fbbbb9dee96433f9387312bf1ba1fc1b6407b3c4b922d56c70fb3d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba74ffe9590a2ba0c90bc9610f88cb18aec61bca25e2e02be3583418152f9470"
    sha256 cellar: :any_skip_relocation, ventura:        "f45b02ca677d362ea3d2a7ed5b3c641b329a5eecc77c6dd11091fe3906ceadad"
    sha256 cellar: :any_skip_relocation, monterey:       "b2335920da4d0e62365204f7d20aa41a5a15e303d806069235b7dcba8afa0a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37eb1dbba8fc70fa60bcf7120c81ac58d6d87d0bf166e0c3d252f400b92bc002"
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