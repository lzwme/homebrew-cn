class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.5.tar.gz"
  sha256 "65d8e9c249849d98f014efe285f2457a61f8a4dd56d49dda067e7f187239ce55"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec2b0c66641df6c7ad6a915051bb114a27c467ea5cbd7c3393761f4203ee6bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e778d92d425434060d81c381a11b0e36d6b604c0bad4691ece8b0237f38fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f977e1405cf05f001a8dfee02157f8c5f8e231d6233d1fb7f63158aa165507cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c31b641c7615e8a0a3c6b8ee817d504fa87e41e5a2cdb74f8ed1698f16c62735"
    sha256 cellar: :any_skip_relocation, ventura:       "fb29ffa182eb7103918a5870e7ded67f17f506d400c477c00540846ba85ee4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bff4c10de8269fbcabf3538f981920d085c05a9ecc994ade16ef667b6dceb5e"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin"flow", "cadence", "hello.cdc"
  end
end