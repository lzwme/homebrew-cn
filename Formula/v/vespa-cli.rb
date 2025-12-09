class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.618.24.tar.gz"
  sha256 "4c83dd7523b14b7ff4d114c7d0bba1c528c79a3b162cc020923af320df8a6b8e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8eb51e2440a0625d60491b74bcca5b7897d8632af93fcc3f0b70eb904ed958d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08bde659d565b59d84a8839fd0f589c70f350afa35cc5eef67ff01c258b5dc15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea5397ef188086057c85d0f7356414d32956b3692561816277ad8d86f510c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a9ea1b1db912f9022fcc14b6069f37d6f4b6b60789f1ee4d1459c057a499848"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db30df3ed06a855fff4b163c35902500dd0e58c22af28c0ea86ae4134faceb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf073647767d0fdb1a6efed16b71e89d047f67682b2633e7f5931b17de3a662"
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