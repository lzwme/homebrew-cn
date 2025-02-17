class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.4.2.tar.gz"
  sha256 "37572bf4d444db657d397d205f5998c200233f9f568efc5d99a2b24c3589fbe5"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e6c08412e58512a8ca996b133172e347def764571d4c466d5f59c70be3c7cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c970891ffe639b44d235909b40f81f7460bd37be4d1f0db4617bc67e97080d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1213c88ed4f0de40e8ac0929b33f116458e50906eed3e352ad66add3a71d7f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "385e3e48477d4381079ec373262455af9c790dfea36d56ed2013ec7adf0343da"
    sha256 cellar: :any_skip_relocation, ventura:       "58969012942ae4acfa05f63ef7e9e46cc6e4db951c87d10ee8a5be18e49b1134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca93f3264c164b7fc25f3350c223c0fd7bea43289d212c36341f18a78cedd7bf"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}metrics")
    assert_match "log_messages_total", output
  end
end