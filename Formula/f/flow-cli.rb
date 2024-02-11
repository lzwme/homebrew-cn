class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.13.1.tar.gz"
  sha256 "e592b29d30c11fdd9f59147952e5d49f7da9383daf68acddfd2265aa7a37bd9f"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2515a0e879fc247b262f9f01b7df1a2311add2a7137f97e42b5751c4b94e860"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8499bd275caed92cea405bfb7ae96a3e52ca84a71bcf96dec73e64785a45e71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c849c00579fc108a9cbda58a71ef4debb586ed1a4fc90b891d0a26d00a5dd16e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5df92d657761de8ff832ee59d80897831b5af392dc275b84f349967582c93521"
    sha256 cellar: :any_skip_relocation, ventura:        "86dce3bc4440ad4a8b290b57ad6273db954a7159e3956025b2b7a5010778ddbb"
    sha256 cellar: :any_skip_relocation, monterey:       "6554b7cc8ff0df0e937ee01ecee92ef38a448de930b1577a94e42cc22d503089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17aa7a3e3caf12c211e0c35da5d3a23a825ec4f638d767fbb9c66c26071bcd27"
  end

  depends_on "go" => :build

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}flow", "cadence", "hello.cdc"
  end
end