class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.258.16.tar.gz"
  sha256 "79dae75e00d9309c0fc49fb30e6c69c08cb02eccb8396a783999c9b8d166096c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d59af9a4ff17ebda7de87ccd9e708101e864262c05ac61ca3e5d62989c5a2385"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebad765049d10d1a7d38090c7b046c22b188f8deacbd5018f3eeaf26e6f6a635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c28a8ea2cc69d0bdd2f64a2574a3f8df9623b03cd8bb61f55bea6c1fd48f0c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3de1c65ad939a3d43cc0d4473a4ec4523e4f2521f00da195ab72e367259c08b"
    sha256 cellar: :any_skip_relocation, ventura:        "c9dac35a724fc2cd6f35046fb038360a5cbb56613562fe7b79a1143dce55da94"
    sha256 cellar: :any_skip_relocation, monterey:       "d7b1a0a8cb6a7756d901dcbe6198147c35efbb71bbdc45c986b82d9a1000d392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc32a4257f0474cec2fa9940cd614deb795fd3406d600e2881cdb529d83c0d69"
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