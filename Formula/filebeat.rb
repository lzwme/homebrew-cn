class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.1",
      revision: "bda40535cf0743b97017512e6af6d661eeef956e"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d53a85c7bbbba28a7a36711a04c133b50aae377af22676e573c7f95a3c4c3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8319f12506ac0b46bddb36f3bbad95011ee7104d4370498cc2c06dc90adbc413"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91aca1905834836c3daacad5453cc64515a8e1e8ae6f5ba21de47c7cc46a390a"
    sha256 cellar: :any_skip_relocation, ventura:        "dfdeb002e991103a9fc6541138f5d3d6151a94dbb6693ae19c78491f8e98515e"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b2e5fe57b9b85e0a85960ef3c3e47ea0400d403e41c7bd7b41a3785a3fdfe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aad78cc025ccb68bec3b9eac37841feac3547873ea77d64a3fc9f9ca9b9ee67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2712eb7cd6727752261d7eaf1a9a111cede897cd1ff768f47fb8b68181c466be"
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