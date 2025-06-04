class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https:www.elastic.cobeatsauditbeat"
  url "https:github.comelasticbeats.git",
      tag:      "v9.0.2",
      revision: "26ce6f2d4c4de66c3b73a1acf3d1be01b817d791"
  license "Apache-2.0"
  head "https:github.comelasticbeats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0143dd46c7019ec8d4890c4b01dec71c91698bc6e535b00dec2474e26b7068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6acb9dd9e1da9e11ccadd720eef67179fd45448a66c0b638939215f9c6fc0a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1218a55aebd0b9575e9362f97f628a9c9a22b2cb05534c5ff87dc2e3ead6567d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed10c2a045ef874559f82082660eb65308675236dec0db1f5dd0d69f3a88798c"
    sha256 cellar: :any_skip_relocation, ventura:       "289f214029b112676b90bcded14380d6f4ea08202ed1135a742cf663d0095180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b18439c7af0b302f41fe0a87377e7f4eb8c1c40c3fd668e838ed9158dd8bd00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbd29223b4754a7d5a5c64b38d0e57dea17ee9839a9a1f855a9028431fd5929"
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