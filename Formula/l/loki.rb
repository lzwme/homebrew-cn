class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.4.2.tar.gz"
  sha256 "37572bf4d444db657d397d205f5998c200233f9f568efc5d99a2b24c3589fbe5"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80122eaab3f380719b3d5635abc2d1156e9ec7baace0d864d443d301a1c8f35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04891a76eeb3559f51d8ce6644db7161d10e56e45a886546945e4c18288cfc1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed26e84a5cbd708147a27c3d2136d09b04188957cc9a86f40aa7b134e6afecb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7672629c2f8b0c7eb8ecb1fd8abea4cbfc99697dc15302e497b9af469ddf2627"
    sha256 cellar: :any_skip_relocation, ventura:       "4ad4c49f5b769375f6aa08ebfbac044f464785822a9df95405bfbed8d1e99715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6c2e258dd202938322fbe4a25704f268546f11ea5e438fe89e2e6ca478d2899"
  end

  depends_on "go" => :build

  def install
    cd "cmdloki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin"loki", "-config.file=#{etc}loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var"logloki.log"
    error_log_path var"logloki.log"
  end

  test do
    port = free_port

    cp etc"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin"loki", "-config.file=loki-local-config.yaml" }
    sleep 8

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end