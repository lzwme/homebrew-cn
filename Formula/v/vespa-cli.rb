class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.651.80.tar.gz"
  sha256 "bcd7b216a8293b0825934664ac5cb96038d2b017f99a096e65025993dccc900d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17080a79c216aa80fb4ae28fb94a42896978ff728c7c945ffef4c56cce5f8572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "614936cfa6c079635a24c8af5f65b8c3fcea46ba4f877ef635f3ed7c018dfb7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7417604b5f619e748464c49544c2b3c58479106985f3b39f4e73802dc36132b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d472675472f8621543d7dd492de50a83edd7b7d0a0310d5760faf1c41de2c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad273eefcd7980f7ede0e9927dc7ce97007e846b85138b0e600356e81059664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f1621752cbc4259719257e7eb94fe02ca740301496c8500b716762d9d22fcf"
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