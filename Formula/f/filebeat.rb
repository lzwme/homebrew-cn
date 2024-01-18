class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https:www.elastic.coproductsbeatsfilebeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.12.0",
      revision: "27c592782c25906c968a41f0a6d8b1955790c8c5"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe97647c94dd93c7d9509b5401e2614b341ea59e39a94b500cce49c16d07a4f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37cff457ab69a998a0399ae55b95cccc58c359d02118a54286685b58247ad241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71a915a837626784b2aeaa7c4671665e4833e5223eb1a8bd37aae305350ba799"
    sha256 cellar: :any_skip_relocation, sonoma:         "f26d33ac8f967b675b9059b305a9edd4b49ac1bb4e47930d51de2f8e15facf9e"
    sha256 cellar: :any_skip_relocation, ventura:        "0e0adf685aed6ae1fd32199248c7caece93fbafc0453cfb94d86a7c5ffde1b76"
    sha256 cellar: :any_skip_relocation, monterey:       "97aa5312e148ec780008bbfec5b9b3647312452be4dcd2c2566444325281cbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6680b01f9e1d780f75d46150cca8413c3b66fb23cc5aa3d8c810d8f70e2940"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, includeList, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, includeList,"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc"filebeat""module").install Dir["buildpackagemodules*"]
      (libexec"bin").install "filebeat"
      prefix.install "buildkibana"
    end

    (bin"filebeat").write <<~EOS
      #!binsh
      exec #{libexec}binfilebeat \
        --path.config #{etc}filebeat \
        --path.data #{var}libfilebeat \
        --path.home #{prefix} \
        --path.logs #{var}logfilebeat \
        "$@"
    EOS

    chmod 0555, bin"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin"filebeat"
  end

  test do
    log_file = testpath"test.log"
    touch log_file

    (testpath"filebeat.yml").write <<~EOS
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

    (testpath"log").mkpath
    (testpath"data").mkpath

    fork do
      exec "#{bin}filebeat", "-c", "#{testpath}filebeat.yml",
           "-path.config", "#{testpath}filebeat",
           "-path.home=#{testpath}",
           "-path.logs", "#{testpath}log",
           "-path.data", testpath
    end

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_predicate testpath"meta.json", :exist?
    assert_predicate testpath"registryfilebeat", :exist?
  end
end