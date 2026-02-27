class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.1",
      revision: "e89803edacde0a21ae1b8aa315f68bee303cf943"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "606d140148509c3cac0fea66d973bf31b8b30cafd0316e765f5037d56843e607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ae73d465b2989775d65c87e6c3100b31849948f78cfb06b68e2f59c18253e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f4bbb5657a17230b3a7aa51bf838e8bf206fea119c4a8f20e434b798d0ca09d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f095288e39312cab156a1d1f2d1ec1b10bc514c2314cd4a2be7215707953c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db2042fec59143a0fa7c725f0f164643e326c91aa4d706e9088916d484b78fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d77f231637598dbe4ba0471472ff7c5f33cb10fc19b2aa028d00159b645740"
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