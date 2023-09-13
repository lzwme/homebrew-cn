class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.224.19.tar.gz"
  sha256 "7d40ab911fdaf1548dd325d4a471c7abbd152dcc5923310e218ed3698d499d5e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2ec3624efa97a16d513d4f707f8ff7c617c2bfcaa3948dcbb6e909282f532fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb07ea54dd497325ac02a536f383df2a432c2fa4de3753fb4614b8586bf160f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bee16f0de2091314f7eca7f01b9e21a12d23a84daa2236eaaf77d11d2b3ad841"
    sha256 cellar: :any_skip_relocation, ventura:        "6f54b38a62b362f153b7a7668d0cf111f701a63017ff92509e2990748c4fd8d9"
    sha256 cellar: :any_skip_relocation, monterey:       "fc11073f6cdd3ac8c4940df75e6f87a76445d125eb95c82572262dc4d6cb8eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f884f922f425d91c236af1be51a204f2584e95b5c94e19adf994ec2c5f21b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec9d51f3af879533f5a637582849ad50165bd5ef85b19a208173e60c5882ba7"
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