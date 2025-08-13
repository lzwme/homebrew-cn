class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.2",
      revision: "b036c1c565cf24c9b720605632234d20cb9dba60"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9fc95338e1e9043009b73c52331990f4875166e2b586244e01ecd23d528347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f65370c2585a6f0e998b1a7afcd455903c5e704c9132cfe2146a82ab479f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c741c1d89e5b02538edbe6caf4bb0684eab3180ec164a1096588a7d64d899d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc98efe212d880d7ab6d4d36a8fc104399c4997db789ccb42a21a341114aaf1d"
    sha256 cellar: :any_skip_relocation, ventura:       "f42374689a958a037b88388b9296ad1567f9c382ab4073559f8d66f460903e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ddc6b338eb64e5178961cf70ce624d7f0359ba690fc50336faf2940595df699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99cea766faf1cc2859aacb06dfcf9f587cad0df6f364c7200fcad82530fa4449"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
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

    pid = spawn bin/"filebeat", "-c", "#{testpath}/filebeat.yml",
                                "--path.config", "#{testpath}/filebeat",
                                "--path.home=#{testpath}",
                                "--path.logs", "#{testpath}/log",
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