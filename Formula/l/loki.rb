class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.1.0.tar.gz"
  sha256 "e5a7c753ab61488495a765efccdc0f4dcddd8639f5f38742df27e3f43aaa97b6"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d833c16c751149aa60ddb12ebb798df81c7a1902dffbec0bc162dbe71608fe8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7904bf6bb0e29120c584ca006bb0df8b90e7bb524e01257fdaf3b93b0c353d9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "985faef9a8dbad58208ce2a7a372f2e1c6f56f7f923cc98b5ad3adbe33877b53"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f8adade48da1e99bb7ff7ae0fe05333ac9654b8c418cd670df1f1199d729081"
    sha256 cellar: :any_skip_relocation, ventura:        "33c270f79cbb61408f5e6e6b899c9400d70ce66634153ff53ca5e0e62b027ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "c2da510375152bbe4d3df0a968e0e5392a24cd0e3faf4695d961e1b666eabe03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4fa7ed92c5ba52300a4bc8e4670f6a1c5076b43151a2c8d44202c05769634f4"
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
    sleep 3

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end