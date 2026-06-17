class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.707.16.tar.gz"
  sha256 "84cf4166e1495e47855d0bc3ef24a35c7d524f63f9db8251650d2f6ab55b3543"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30742a1bb85c11fc708461a9c2886713178931353739478bbddf40b863ff48f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b59e785c064596b5560aea0710c61c1fdc8de174ac6ce1f3584eb0a4a0070e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9881d0b4a802ba2fe72afdc2ac812dc70138502f3c17a7329eca7fc885cbb29"
    sha256 cellar: :any_skip_relocation, sonoma:        "85567bfe0d1ad407e4621e47757405bf538341dc5627d4f8ae98b8dfc17dffc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dfe78b7d60452b9b691b0b501092951bc1ca79a53c2b38e1423dc1e2bc07034"
    sha256 cellar: :any,                 x86_64_linux:  "a4ddaadc598a30b701363f39e20ccfc85e9acf7a4030a9cebe500a4de0839fa4"
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