class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.696.20.tar.gz"
  sha256 "7f20e73e1275049a9b6a5b474ab5377648b23831b9ae73e5facf3282a1630970"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03dc4df4fccceef451ad329f6e34e51a3805064046857bd095cf47375cb60fa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15874b083d197e780b1dd21c3b1dea39ca6420afae19ed421db5f1389d2e7997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7643d21eb91167ecbb51d02e178af211fb30e294cb3e933357ccf9235663dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb0b5f2ac2a890926adc82d4034f636698cb9d9368cd7980f54db6ebcec81a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf754cb22d368081eab3b5847935c8150d0f63a463edfbff1a93ea5f7b6b78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a12a453382b5fea47e1b2ba1ea3984cd1f3206a256e6f589c0cc58f77dd951"
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