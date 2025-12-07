class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://ghfast.top/https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "dd15eff423f5baf8b802e28c7f9722363803635414aa06eefe8c5d637f16d4b8"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f53df08e575ba3ee041ab6287d9787a2edcae4b0dbc828cc0b7022dc582289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e72cf910c8546e80454e0f371063275bfaaab70da14d28314799539e16a09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7a546ae337af8fc588695e501422e20b5bdd6677727c3633d84e019a991751"
    sha256 cellar: :any_skip_relocation, sonoma:        "afa4b7c6ef0f6838420146d1ac97e381a9213f7d447aa57180e8ab05b113409c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a90cb68101f273540a09927b0f5d48a7986a615a4299f76b6f8b867152d253a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d54b84b19ea0283fec9903cd98daa7fa3ddc3e786dae5b1aa5a4bf98d686a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end