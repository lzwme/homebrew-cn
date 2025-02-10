class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https:github.comkoki-developgat"
  url "https:github.comkoki-developgatarchiverefstagsv0.20.4.tar.gz"
  sha256 "c7884e9594f2f7be86bf62361c1e359b4f9fb5ce924ae7a8ef5c3b136c3b760a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf9b0ad474b0eed68ee13096ec5d05d39c2e5acba27f025be96beece857ea00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf9b0ad474b0eed68ee13096ec5d05d39c2e5acba27f025be96beece857ea00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cf9b0ad474b0eed68ee13096ec5d05d39c2e5acba27f025be96beece857ea00"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3734a9f3a97695ab910aad03027bea51e14eef05fba624643bf8f9e8c020e2"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3734a9f3a97695ab910aad03027bea51e14eef05fba624643bf8f9e8c020e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89375da0bfa9c66de11538e8fae64446144e0243d4054109be4502d3af340f1d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comkoki-developgatcmd.version=v#{version}")
  end

  test do
    (testpath"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}gat --version")
  end
end