class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.1",
      revision: "1292cd58f48325c041317d9a8bc1f1875bc6cf5f"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d49207fcf81e90476be49a68d74ebfe8ade54bfad0bbc2f64194380a2d94c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3482026fc31cfec997aeb36b213a70c6ebaafbc1d734aa47b6618b352bfa6699"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3fd2e2f22bf9e827fb8283c8b170eedcba8fd038b58e89e1169319f0182536c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e7b5497e06da78029e1b1583ac3cfae582b0102c62f243a428762f0a7c2c693"
    sha256 cellar: :any_skip_relocation, ventura:       "d4bf5ed9cbf34740b272b8b84cf92122cf72ebc5304c3c4065880ff473a8ceea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637c3615f4f23953d2a423b750621350379855f057be2c7dd26f2fe5f6042c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a2b09ea53aec1cd36aa0b992c9b38b24c01f660c124045dab20ec2c168f4e1"
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