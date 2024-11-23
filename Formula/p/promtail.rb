class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.3.0.tar.gz"
  sha256 "b36148586da9f8b58dc0a44fb3e74f0d03043db2fcf47194bc9d145bf5708b3e"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "468e01d0a751096243589fca992171ac475825bc27299d94556d0b08d2ee57c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a93458085926614dbca23ed1460c3cc10dd94d0f2a969ea66911680917902dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3ba080efcbb7ebe6c68c9b6b959b7663f58890dca092b6837e92b6239311ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec6cad160b834e20b8385c44ab074840d08544b39f2cb7f029d6c8f5e8cd65f"
    sha256 cellar: :any_skip_relocation, ventura:       "5cf08383928c7a5536585ba4bf246077896f5f356507358e62f573a0a6f572a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "079170333008873fcd6ae35246e01bee52d86b19e6e7884cb6982426580e1cb8"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clientscmdpromtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin"promtail", "-config.file=#{etc}promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var"logpromtail.log"
    error_log_path var"logpromtail.log"
  end

  test do
    port = free_port

    cp etc"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(__path__: .+$, "__path__: #{testpath}")
    end

    fork { exec bin"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end