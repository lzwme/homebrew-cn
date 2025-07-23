class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.553.3.tar.gz"
  sha256 "3fd2e2489c34b0c077a6bd39747fde24d39d9533dedacc1471d83d5a9b7a21d2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f014eb01c83ad074463f802a48458048d9e9f558b1f2d5102ea56831dd665f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de671f62346e2b6653ce3849b2fcd0ceb4f99598cb044cfc6ad34be7c45777b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "544743b2736c6a9359fb1285d9eaa634aa14fc10fc311665c52b213c6f0b351a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf9c0de3647d1c8be8b0ea9d79fb921e37ea685b07c45f0e9a5f3f89d2e44d5"
    sha256 cellar: :any_skip_relocation, ventura:       "f0e7dfb53ce198095b9883f0a6aa4780510f22e14c59d9094e556fa7ff73c0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f4ed1718151c6965ff403163b61558e47dad404eadec921a78f2e04ce04fd2"
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