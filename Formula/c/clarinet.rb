class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://ghfast.top/https://github.com/hirosystems/clarinet/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "421193b19d89c7a1e01cac9fe0c7a18549bc26d9954c59e6681106b2a4403bbc"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e28eb85cee90900ded151418b127065cd3b1a062fd06d50a9bf04e63e11ec73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98b04240ac72915d99887ef54377c63c9ecd2df29c85f7ca7afc86acd6f75f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cef0ae12e1ff2ea32463ca943e17fdd2de4201264e834c4ec0136fbee368da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "98a0cbcea99b17eb542ef0c5483180e588d0f4870b4998960c30bf7e6831ae59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a0834f30a483741dea101912a79a7a46daaf1654ccd57e5879fec3f62dadf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6edd941df6de42e8081856ff976adf7c48bee118534a504d00bd41fa7e384fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end