class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.217.46.tar.gz"
  sha256 "fdab72836aa0f6e9c29cf973f3abdd03ce770833232d8a9b4893d3fd05046681"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a6554ee8c3783ac0b1994301e0ba9afadb6f85cd43bcff16756116d77bcbe95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f83c2604fd9a99d375da0c9ddf937885fdd68309f14ba23ccba71f6a20e5902"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a5ab15269ccf6d240a60f0bd71098b242c9b72fe8e74f8e8e4969cf29b9d33"
    sha256 cellar: :any_skip_relocation, ventura:        "6f33e523023eab9df7086454819a01a32e8ab2ab93c11d9b6294202ec953234e"
    sha256 cellar: :any_skip_relocation, monterey:       "48ffb09efdd2f1d23698b2bf59218b5994ef57d50de3124a8a3d237f833ef904"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c6cd7e60106fe6d3ade48b994c08d58a4bc846939a4283ce6643d765fb93669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4fb6bebac5382c0376f53fd49305b239c66f34ee6ee213c155f704f8196163"
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