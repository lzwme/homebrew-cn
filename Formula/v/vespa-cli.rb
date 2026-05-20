class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.691.19.tar.gz"
  sha256 "a8bf3663c0894d158da2fabf2675df4425aac90b52d02542bc485d540253912a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64225c99ea52a97034dd844cff701b27ca4cc5cee325533dd4a671d9798cddee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a33ab83d0ef7feeacebe4f227aa2994c00614b33c5ff5f146f8c13551d770217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9938f8d2aa33f175d6fe4910117c1e95c21cf1bfe63257ab5895b408792d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cbe296fb83e901f255f4038c5c2505d57e4efe667760d11947abca0c0a38540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43580e0fff0cb26ec732e319574b3ac66c25992c8ae439ef3dac4230ff0fddc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b14925aae0cffcb7c4b6adba0e897d63f5384750c98eb3ef6632ebb277e313"
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