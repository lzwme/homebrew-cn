class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.556.6.tar.gz"
  sha256 "fc8048fc791d9d97a3d9209914295aa09ef0f45f3330103bcb121b2210296e0a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6316748451c2fb04c3be3311d9158186c3fc999d8cc6f305eb545b2dd43bc30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee436d4699f31bff3f9af1d0ae68caba98dc655aef35ea34acc77c8c0b0f0af1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c954a9126822dbfab56503ef120b1751d9ea0ba02975721214ef714bbf36a06d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bafbd2eceed14d9a868c96c1f338ca1b058bb2e96562167cac6a03cbf992e2a5"
    sha256 cellar: :any_skip_relocation, ventura:       "32d6e848a91a6f4338163b9b25f8d986724cb5c0f91900d94f6c31c1f383e6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70f031c9944063f020ad8a64a7499acac2fb19b665e8ec7e71121201c344ca9f"
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