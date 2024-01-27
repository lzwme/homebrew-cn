class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.12.0.tar.gz"
  sha256 "b348a3b3c5df76d6cb09d83065217225b6e37a43b414f08ce61ee58550d4b6c5"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "076580f2fea552bae588c12da8217ff6d9fbc4fc286c97614bcc6870b74e890b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a391baa31d1c08147373edbc38356558cc8c602a457377354e54e778ae66a2d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c3ebcf2d7bddf55d2708a08dd03da988f6e3eab0cd642dde7f8591446ba9092"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ee4698c4a710dddadf58c14f4e37360dd6ef4e11ad5ae062095e335eae517cc"
    sha256 cellar: :any_skip_relocation, ventura:        "3f6cbf6a58a0e53dc7cd81ef51e023217eeb615396d3c25c4704b86cd15b221f"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc626b428d8c1f3f6c9b043c276e0f9ff69431d0c074db4bbbaecc432cbd81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05ef3a8cf4ca259c5e00c04e2ad07660bfb5a00c19c4fa40d3582aa929275261"
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