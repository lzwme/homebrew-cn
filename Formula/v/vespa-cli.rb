class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.638.30.tar.gz"
  sha256 "75d430253b8ba6f22455d48cd09f46d9a1c352eb172cbc8c9e6cc3be0a3609dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eabe9ccf052b8930ca11c7a6a6e77535f06529474532706a800c5f34c96662b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf350af446fc210ff81f403580483257a137563043a7f0c9edeccf7cfdfe4c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9f483d21458245e97822b1ce4d281ec13177faa18b25df915121ac6b0e25ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "3655aa32df6d5670db81f5f5736f6ee72901d6d7083a1166dc2e18db718b3c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa1ff405db2ccd1f9691c0d1cad765656559fc8f8b4706b232c735d207e2227d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cdcb4464cf61334cdf9c8cc2e2674138cdb92107b8d6f122093895a146d2eec"
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