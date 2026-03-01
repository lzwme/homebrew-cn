class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "98767e52f543541357315155f9229fe2b8b35e8b4cda01cfb5ba061a1e155f12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abcdda5e96ca1ae7546c7b2ead017edfe213e5f2760c8a11e9cb9cd5ca011834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abcdda5e96ca1ae7546c7b2ead017edfe213e5f2760c8a11e9cb9cd5ca011834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abcdda5e96ca1ae7546c7b2ead017edfe213e5f2760c8a11e9cb9cd5ca011834"
    sha256 cellar: :any_skip_relocation, sonoma:        "4efa53e13a3276f786e42f9b2754cd98037dfc20afc1de140948e7b437ad3c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52c82c47e1bba93d1edcc8d9502f8ea9b5e5126e6f719b8eb5a45c1bfc0844a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba07596bfc240d12385ce25ee071d393633e0b1817f98d12000e43321e29fef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end