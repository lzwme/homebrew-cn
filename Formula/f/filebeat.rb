class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.4",
      revision: "4ce96ccbcbdd9b4f149e1af9ff2a48af7f42ade8"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c5afbd35ea6935e9dc91a8ebc0ee0c04b787732aec08e61d0cf76c726c60dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c30f750ed0d65bdaf59bd9278ca531ff7cc67f3a7445c314b414f2fcbf1261e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "023a90c6ad06f7b34912b9d433eb937fbb49e8066435fe27d1486efc4c0f5364"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a11537ba307a3440ea7b77ab610c7a6a19b89752aab9755e9fe7bf72b0bb36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e1fed6f25530e7f7a025b9b3a4225b1a4286eda443dacf032b6ab36bd7aa10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48bdd4cd6e11476db77d3c89506e8c62250e2c91e2fc3ff39a34294f4c7aa3a0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", /GenerateModuleIncludeListGo, fieldDocs,\s*filebeat\.CollectDocs,/,
                               "GenerateModuleIncludeListGo,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["filebeat.*"], "fields.yml", "modules.d"
      (pkgetc/"module").install Dir["build/package/modules/*"]
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

    (testpath/"filebeat.yml").write <<~YAML
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    YAML

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"filebeat", "-c", testpath/"filebeat.yml",
                                "--path.config", testpath/"filebeat",
                                "--path.home=#{testpath}",
                                "--path.logs", testpath/"log",
                                "--path.data", testpath

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_path_exists testpath/"meta.json"
    assert_path_exists testpath/"registry/filebeat"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end