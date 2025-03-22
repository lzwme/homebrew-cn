class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.16.6.tar.gz"
  sha256 "515b1603cb48520c9034a4575f4eb83cb188164680a2632c163400d938e25d2b"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a9a0ad59b96b949e7d0063f1ffc85ec91012dd3c8b931e53889cd60c71a84d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a9a0ad59b96b949e7d0063f1ffc85ec91012dd3c8b931e53889cd60c71a84d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7a9a0ad59b96b949e7d0063f1ffc85ec91012dd3c8b931e53889cd60c71a84d"
    sha256 cellar: :any_skip_relocation, sonoma:        "294f4113fa48ab9b7e7da97d94d39489ba751c9c51156ca2b7d57c910fccc7b0"
    sha256 cellar: :any_skip_relocation, ventura:       "294f4113fa48ab9b7e7da97d94d39489ba751c9c51156ca2b7d57c910fccc7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36436a888943f7225edddd1055f8409c6b62f44a1ecfe7f21a5dd7fbd239720f"
  end

  depends_on "go" => :build

  def install
    # fix https:github.comasdf-vmasdfissues1992
    # relates to https:github.comHomebrewhomebrew-coreissues163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdasdf"
    generate_completions_from_executable(bin"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asdf version")
    assert_match "No plugins installed", shell_output("#{bin}asdf plugin list 2>&1")
  end
end