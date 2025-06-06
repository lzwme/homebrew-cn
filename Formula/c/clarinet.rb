class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv3.1.0.tar.gz"
  sha256 "9f072a28f9d333683fdefb68a23d78ccdcbd05706e06bf103cba815854698a18"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f2c12cc40c9737c3bcbfea7250d2adeea96e218bf7e1d88304488f53133601e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcab3dba8ada1b2080f7550a63612c69971418cdf68e1bbafee54b4bd698d5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52f608ef13f358c824316eee3e3f19da2e73b791c8d0ffb83a22d0a619cc8b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5af7c635b4791b2f877e635caf6c107f8684e88e5668b211a9aff0390d029b5"
    sha256 cellar: :any_skip_relocation, ventura:       "1441bda8f91443d2bc8214352c1a307e90ee48305b8ba83ec42caa9bfa9db8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f16d6556bb6daec82efba88f0c2cee8664270a0927b90dc131df47afa6762bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79813bfe96bca739311fa7d13dec731bef42e4f17ae74dde2395c65bce90eb9b"
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