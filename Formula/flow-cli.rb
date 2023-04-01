class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v0.48.0.tar.gz"
  sha256 "e804b3c25ae68e172e8259e52db6c30cfab991b7cfc816794c7465f6737ad461"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d5316ee7e9d47821204638a73fac69428df322eec884a4414c8f7ab67200cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10bdb4034650772758749c2df9741b27eba81371558c59ec98d500048fea59f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ffab8ec8aee9d525f20673dcff6d51f5f77ff19aa96921cc14d90afb47e6946"
    sha256 cellar: :any_skip_relocation, ventura:        "c0ffaa51c721b78a5b82e6dd1cc27d71f4050fe19336ed44dad7ae0f4f2ff43c"
    sha256 cellar: :any_skip_relocation, monterey:       "5894ed4e9414dba2d5b04e120821eaff9772e2de2139c7551882050ba13a9cdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d0366162f143db3a0b477a17d14bbd53cd55a5472d710d7d7aa12d59bc01fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2309c73846c683167dbbbc175d5711cb9795576c24ae8a9528187d2e64d37bba"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end