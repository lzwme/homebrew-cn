class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.164.52.tar.gz"
  sha256 "f361d543b3efaef57644207336004455b829e394e1a450fa8ecb45d0e5b094fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3a951371024b06f3b6d8c810026e5390706e9e019e5ac6727c12f97e949c641"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d1c1eec2433868e8728ffd042744fdc5a646219a664f7dde570fef36184050"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a54df385426a7baeeaba9cc21d5b783d390a989b40681638fa5b76328ddd2cb"
    sha256 cellar: :any_skip_relocation, ventura:        "140b97d3ed235220ffcf91dc476deb8b539f450b9343cf4c561137f1f9228cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "0f169d345c19e805f4b0521cc8d6399ac8e85bca46b765486c66f1a8f78d4483"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3432c24053c5e1fdf85958456045aa6f8ddfdf880afddba2aa160f9a88ac9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7251c38024140d98311c60af1a94a0f03733da96be7dad815d73faf4293388a2"
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
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end