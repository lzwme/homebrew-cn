class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.13.0.tar.gz"
  sha256 "997ca7d7856a9798895fd56c6f17b2cb3d250ff7976c8606fb37f86f2425fefe"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "413a28da193c5e4b035abb47ada7bc7a708ae10d507b7e08f29e1effed0959da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d864699f224710cf57e36b92111d447230ae05f16a228d16779ffa6799320e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93f4686dbc76160def88738c163f81099b99da16afdd946411c75ef6723c6943"
    sha256 cellar: :any_skip_relocation, sonoma:         "846db20c1b60e4123e6c8aacb58847f8533980ecb37b5036ab43da91603a4be8"
    sha256 cellar: :any_skip_relocation, ventura:        "087b63c59c955a64f47923b3651de18697aa501b34ede85f9b8155cf65394928"
    sha256 cellar: :any_skip_relocation, monterey:       "2c0693df951b5e381b3e780280afaf473d68ce8718a4d983981fe02148e1d46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd0789134a117a2f8f33b72b5f02ff07ae8cda250ade17d6901c22b2323134d"
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