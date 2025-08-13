class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.562.17.tar.gz"
  sha256 "8cfddd57b9a6fb079d628974c0d6a6cc8de6edf0ba2c20d608826d74157401f8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73d3a643904c5dd83651ed2e1669454f5afc2ba4343e9e960b5426963947ed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5415f55cd402667d0129fcd642c088bb3f96aaf0a8c0cdac099336a425055bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aa2dc908c7cd219160ccc7f935a70e911fbdb1055caaf46241eaaa2996ecf78"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2e653b1f104f0234df23840ada0fea61a956da05c51cb3b0b4191edf5dc3f5b"
    sha256 cellar: :any_skip_relocation, ventura:       "98cac22d2bda29b82a11a48b8ca62606a5fea4df9d6e757d327dd5eb1870bce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c189c203902d883697d650081696efbcde4b50c40e8ba0ae4e17c1275a2d925"
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
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end