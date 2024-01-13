class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.10.1.tar.gz"
  sha256 "2e4f5f914a7b8fa4cdbfeeec0ee0b378fabfe61d07eddc7c61ffbe566d080cc1"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1d388a94d201b13559f90fbc8bf0f3cde7168c7f323b53d05618effcc36dfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d722f3d739dd03df6b05525e9f4fbc74b825945f8ffc4ca6eeb1003a0b029a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96c68b99268d26b41c64fd586583fe8f2cb2f61adbc85166a976e7fb50fc36e"
    sha256 cellar: :any_skip_relocation, sonoma:         "22ff1095c4c7b1ff14832f893fad09eb66a8de1253af69acde2c795a3003fd4a"
    sha256 cellar: :any_skip_relocation, ventura:        "7eed95a42343e9ca5a8847aec4e5c9e2965295eede2a53ca4e327f3f8f0e68c2"
    sha256 cellar: :any_skip_relocation, monterey:       "012c5907879cb10e22ba0faef1ca6c5a2309219515452947fc8327a5b3f1a990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fddbdcec97eaca2e309f2636c9eda448abd458c56434df42fce7761c59bea66"
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