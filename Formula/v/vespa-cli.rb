class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.600.35.tar.gz"
  sha256 "3874fda98380ea91bbb6e7b183e1c4fb896b25518c7645f32b445b2b4be7736d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c0ac1b744211a252a9901d61c9a198f99457257ad05db492d470bb9a2acf6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "481dcaaf33d503961b36f20e0afa2688e6c52f0c2fa3b53a821b0813081c54b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c608ecc78cbd49dc25477f009916e79620f7e528352fb3cd712e250ae52e71a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "889275d114f64e4f7f72903456e55d9508c0824f6a36e54489f688acd91e8622"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a22da97e465e19b519e38431931ea25a2baa74bd88aed39c7713cbcede1ab15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55aa485483a2e5dafb066ca644a7c03b7b73d88bc833ea7bb5a7ce1d43e3558"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
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