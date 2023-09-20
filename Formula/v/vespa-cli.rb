class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.227.41.tar.gz"
  sha256 "32a8a530d9198df47a7286bbe3ca42e0e80d4e16decb26ff25a93b5da5b5538e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ca1d7b789311d7297eee3883b6b14f94e432d89a07b31603bf56eca8d472d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada09896b959f7fd5daa52259113ddd0278c27457615aeeaaeace229731ae728"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "328f2c0d1748de4a3ae91007a7c0136fe2a142d9b7ab347745b87b1788695f49"
    sha256 cellar: :any_skip_relocation, ventura:        "9a894de66c4491149f0f22d8f4c89048feb882733a1b5f6b87edfac959a15b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "b99b7da120405ad18197cf1ce9733dd7ec3011d8aa3df4b5ff9cfe22b14fcd9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "84ba3fc20c4dcd4a9a9d906b6e5f5a0601ca21ec2e5be9499148089a734c2210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1875f9eedf455964544eb6c87e58cae9157452b56e0d5ce227ff997f13466fdd"
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