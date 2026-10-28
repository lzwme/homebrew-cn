class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.778.45.tar.gz"
  sha256 "24eabc6485d1ac46555ac3648c7c3ec5e0bc441a2931f996c377e1161cc034aa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8c1ba8e22338ef75bd2a09a56d1139f12decae29b63a517139b14bc904d4387"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e49b4ddf72b7dc7e898789eadce596f73af8abef9695d6153d5a15af972cf96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f469111759f11ddd4886b32ba5eba9bada1a2ee8dc24aca5fa6f036cab33123a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6029254b85c9bf5cd9ffd1406cd73ab69a4817c3f9cf5606ebd1e7a52732c5e"
    sha256 cellar: :any,                 x86_64_linux:      "9a7821ef9f2214e6e262f2ca54fe50414bcadc12010893e17dada56b5ca78cc0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "client/go" do
      system "go", "mod", "download"
    end
  end

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end