class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.679.50.tar.gz"
  sha256 "08ce8ee5638379cecfa1619497a97c5c672e98f38ede00a03fb24b1ca8b4236a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ba639be6d86e10cad1db7212f352a5d84aeb04190ff4ac0116233dd95ccf33d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cede5ddab7ed28648b552ed0fbfc2e1d4c79fe31e0f4ab5bbfb959f1d17d4387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bebf8eac97def2748c4024435e0e292c02e8c0abaaa29b0e571341071393d2f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ffc151323eba6f7e3fda4b1371537dd19c2b2f5de8ecaf28aeefad197ea0696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5c488e131749ef7408ba10901324c7426f9488d0b887c8b884723175ad4bb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25fe7aebc9702574b60685c82b03446c215641a2e4cca44a553ccaccad8245e"
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