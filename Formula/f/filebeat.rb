class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.5",
      revision: "49b225eb6f526f48c9a77f583b772ef97d90b387"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d26e9d21231aaccde4d088f5cc28dab0694f3d0c3f29cab5ed7d714462428c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ec760f40e473a2a07be6dca653a210fed4adfb8adf4fbc0e09a5bb9a43f236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2adb63a4f2072e6fc29d021f209dc3e717c2c84d2e6e7b5f5540e8f233338233"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47254c8047c1c3903d711d4fdc5bb36fdf287b2b19ba8597197b9fc0727300a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ea0265fd449b0987706cab7e709c8e4312afa0697d9db3bde4dc84e0650ea83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3988ba2fa2f927c05b76cc6341d4faaed8dcad80f360719530b2283f6341624"
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