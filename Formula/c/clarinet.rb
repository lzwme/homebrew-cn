class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.15.0.tar.gz"
  sha256 "5a825b156f76912b84e35b65d3eeb54cbedaba0cd0862b970074820d9324beb0"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92bd6b56cfffeb9992176e57134189eeb9253e50f3ad7fd6f086d315d77985c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df01d10e5d00e74512c2675c16056af4567103080761a6c1810d61e2e8d2dbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b4215ea33422ae3b84dc6a0d19e4d712939ac3aba654074a868fd5f11ba3a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9dc2d354c7abeec9b063b5ff981e00d90e54c758acd2aee44c7feb86206b20"
    sha256 cellar: :any_skip_relocation, ventura:       "506582caa669b1f9139ae00155de6d25a154978a5b22e9edfe665b737867a333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ade8c650d051e3b4405a874be8ae91fd7ea5e61be63667d3c1f2902d1e7daf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "componentsclarinet-cli")
  end

  test do
    pipe_output("#{bin}clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath"test-projectClarinet.toml").read
    system bin"clarinet", "check", "--manifest-path", "test-projectClarinet.toml"
  end
end