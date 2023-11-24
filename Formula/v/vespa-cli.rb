class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.263.7.tar.gz"
  sha256 "a550f3b0320fed6cf2808710b4d6319428c4628ad4fcd5302cbcc555d2afaa5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d03821b106a4c72459b095bef2007fe0ab5cf0212c5acd90416bf156f902570b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c8f11c9b95a2ca9237ef35a909ecdd07b202e7675d268dff62186632ad5cf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4795f8eeb8015450ea8f16641d626c2cf02c58a6a8154155cd1c2899b7166232"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cfbd2584471665d20df0316ef92d2ed833c069ce9dd6ca8352c0275f9e8307f"
    sha256 cellar: :any_skip_relocation, ventura:        "7894be0ca2a2b3b6ef6435b8630d76e278aa78fc5175a50b43208c37e7331d22"
    sha256 cellar: :any_skip_relocation, monterey:       "e8498fc26eaecbb07a61369280cf3f89a817a51ec479d519a0d95f901bd22604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c285854fc26892e5d952a425bbfc7b3f350dda6883b76a1d616009977fbb775f"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end