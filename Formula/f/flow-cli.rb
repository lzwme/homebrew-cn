class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "6979cd399e7b51e9cc4d61428b34c83f2e980800bb61372a761b84752b0cde55"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc3c0eddfa22ee318f8e94e47988ba44a18e489428cca0a2e5174199cedf2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684c0ff8f7dce56a9c8b8947d962d6ce9f1688a9ad9d065b9626af00323fddac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4acba459c5ed63bad876415adb1f91de360d38db9e679377a81ada6c4c83c23f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7124359872bd51041bb37613f35f8e32b945de3b089352af298fac21c2c7b417"
    sha256 cellar: :any_skip_relocation, ventura:       "9e715d4ba747b0344eb2ebb1b238d7bd6e861f83d33ecc5d89af78e91ca9b6e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0679a376a1756b2e91c089b4b6272af96093a1e8540c2818b23b7e9bcd35b55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6251105ffeb98ff6ffb1ee847a0107a584c3040d5cbb589229a185d46ec5be74"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end