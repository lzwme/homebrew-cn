class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.17.0.tar.gz"
  sha256 "47446cd6007b743ee207541fa8ebcddaae2c988f4cbd9dd845a2a7806d5d2f90"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4c0eec0a8be0893c7c2b2a85bcbefe34c2c704d80ea6a48f9169bdf8ebbb0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b4c0eec0a8be0893c7c2b2a85bcbefe34c2c704d80ea6a48f9169bdf8ebbb0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b4c0eec0a8be0893c7c2b2a85bcbefe34c2c704d80ea6a48f9169bdf8ebbb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b390d15fb975f467d2bfda6dcb6fcf94889ff7d3d7c331427de145aedbb0f8"
    sha256 cellar: :any_skip_relocation, ventura:       "e1b390d15fb975f467d2bfda6dcb6fcf94889ff7d3d7c331427de145aedbb0f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2454e692672cb020223dfd8319403a8e7a4be44560ed18399150eef92aec682b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b47178c6ef8fa25491ef83de6ba7d6bda76343d714b6b5ba321c98c8bda7a91e"
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