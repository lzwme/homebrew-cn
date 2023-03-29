class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.145.27.tar.gz"
  sha256 "7bddb72c697d5865698dd07192a14dfb272c837e138973146b898172bed2fb74"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e74c00578dd3961f05429a64d6d6deb34481a48cd772f188d9b85c956345df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4116d7c0737cb1883eb7cb98e8821f67f98b4aaaf05208e27f9a4c350b20b706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f41b579f43e46769ac0dba2de025ebcb4edb0ae5aa0c6eb7b63701d4adff2d8"
    sha256 cellar: :any_skip_relocation, ventura:        "e481cd23e6eb89b154f6376776ea48eb2fa7970c3e77033af16c6ba830ba13d5"
    sha256 cellar: :any_skip_relocation, monterey:       "82ffa25a51d3d27483874d8cbccf9f0a359bc48bc3189efd07ef404d7f218591"
    sha256 cellar: :any_skip_relocation, big_sur:        "80df94bbd5869ebc0c6b4727a2f29e5d62baeeb2778aa4df3b906bb33ceb0c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad38b6219a63489b54aecdac1c1d7ed2da11e426b75a59459c9d06947d9e4b0"
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