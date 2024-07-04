class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.1.0.tar.gz"
  sha256 "e5a7c753ab61488495a765efccdc0f4dcddd8639f5f38742df27e3f43aaa97b6"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e725c260d1a3e890c64f2a1c1881b1f9456cd7b635b529c4de086cb59956050"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ad8f11ef7c070c3aafb095dd0b92caea4eb06231ab253b416db23573144189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71b49aa82b63784dcd6a7ae99e3d7d106f32558398bc7aa36daae48838ff462b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8615481420035a2196d48825259a34bbd4ad2364fdc74222024f26cf6043ab6a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d006031806fbd2636312a71046869ef4417a1674444a26e7b1d6169fd952f73"
    sha256 cellar: :any_skip_relocation, monterey:       "6d44ac4a8aa173179c303e4a48153b8dd9861439c5fe8f3d3d46aac1856e7cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c747c9d2fd8e7df7fbf3fc4f235abb6d3164fbb4646bbb98c48f0ee89d874f73"
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