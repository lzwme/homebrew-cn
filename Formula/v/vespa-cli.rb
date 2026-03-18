class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.658.52.tar.gz"
  sha256 "4c9a8ffdcc771b22ae14c30ad635e4a158323568ddfdd4537536a1caac8809de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb03c73f2497a8ef341e2e5a074246fe32d13b592f38144a352edef92ce77ba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ee1194993551c824722cd0f787c37fd70ff69b51f7d1cbd9f19e2fb83fbd2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac95109aca88aaedafa0598686c5274a3531e780dc2857a7ab84f39b37731a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4be924cb0bd00b0e925441c8a7c2580319ddbf0b1d18912c8e09afbd85186c6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4605e86c6a8e399683b91a786490a6f8cf0e2d792069c6224248855e80911ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a110dbd6283fc47fe5f06d83dc5218c34fec73b708bfc33885e910e8e77aa7"
  end

  depends_on "go" => :build

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