class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.151.21.tar.gz"
  sha256 "f9e5c3d4ed26c8267cdd37d9c417ce728ce610c63fa6b4931a197338fe8c7596"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4512362150cfcd1396bc51b00b278532e4f3663ce67d04e8e9fa694a6d2d20f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a645ce79e1c1931c0a14caa53a3e94b4afda4f9afd755728cd428958c868ba88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37f1b1b8b63f51fd20da74a0844be9f73be450534209b1259000943d00decf24"
    sha256 cellar: :any_skip_relocation, ventura:        "d4255b0dbb33af37b6ed623a09dd7a7e8b9de0263fa53b84263eff07525ef8d7"
    sha256 cellar: :any_skip_relocation, monterey:       "9087c07d45dd77e14012621aad85992f0703747b314e18675511dea2f53d6539"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecec149f7ba5834f00757f1dd075f1a108e4a7b0f4919ffaf88c647ae7a6a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52186b0289003393d137b69761564d0ad868c594c005eb4c4dd79cc3622ca674"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end