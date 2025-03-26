class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.cobeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v8.17.4",
      revision: "5449535b768a9308714a63dc745911c924da307b"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dd7e7c3bf36c685ed2b5ab07b0bee67788139bb301b768f2b7b59717801e420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "654e960beb52dc28aac6cfa2fada48fa0afa3f58eba12f1b9ad77b471402e38e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c88fb7e5d67ef95d57a94d65089ced4a3cdc2387870bc088e4df07c2163c3284"
    sha256 cellar: :any_skip_relocation, sonoma:        "da82878b7a614226b1553f85d8c73323fae9df3f44da76a6a19ff2aae11b4099"
    sha256 cellar: :any_skip_relocation, ventura:       "6095a5408296634d3aeeb8f4abda672f610348968e76b8177f145c9f10c4d971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903950fe733cd56a11856003ed5dbeda19f67ac6187eef9acf5c9ab573f584d2"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSSx-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec"bin").install "auditbeat"
      prefix.install "buildkibana"
    end

    (bin"auditbeat").write <<~SHELL
      #!binsh
      exec #{libexec}binauditbeat \
        --path.config #{etc}auditbeat \
        --path.data #{var}libauditbeat \
        --path.home #{prefix} \
        --path.logs #{var}logauditbeat \
        "$@"
    SHELL

    chmod 0555, bin"auditbeat"
    generate_completions_from_executable(bin"auditbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var"libauditbeat").mkpath
    (var"logauditbeat").mkpath
  end

  service do
    run opt_bin"auditbeat"
  end

  test do
    (testpath"files").mkpath
    (testpath"configauditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}files
      output.file:
        path: "#{testpath}auditbeat"
        filename: auditbeat
    YAML

    pid = spawn bin"auditbeat", "--path.config", testpath"config", "--path.data", testpath"data"
    sleep 5
    touch testpath"filestouch"
    sleep 10
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath"databeat.db"

    output = JSON.parse((testpath"datameta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end