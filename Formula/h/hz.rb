class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://ghproxy.com/https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.7.1.tar.gz"
  sha256 "b77329ebc4f8c6e53d749d61e4a46972044ff209326f3ba8e5e8e9c412162d46"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed49a6df3513810e21402945e340f81a468532a2b0947d90b92cb6fff498b832"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9526d6010a93caad522dfdb9d1e5d2c1a7164e3d2516e1e42ad04b6248debe0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35625950d1f5f7dc7a42b75a9dacb0da635e30d8f87bf2ae2a4d82e3e9899e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "180e9ca1ca74f4a1dadaf164742dc9fc22e0c9e9b1156164d5a2a42997d77045"
    sha256 cellar: :any_skip_relocation, ventura:        "dd1d4c4b6caae1510665542b7a10071ad97dd7a7aa947288eff2122b6f001b77"
    sha256 cellar: :any_skip_relocation, monterey:       "fb8fb0456fa2858fb636e852eee1d0c1bc356cce218f1db484492e94216b9dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d499695df3cc57114cccdea32642105a1afdc6ee58300bc5e723d695efcb4103"
  end

  depends_on "go" => :build

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink "#{bin}/hz" => "thrift-gen-hertz"
    bin.install_symlink "#{bin}/hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system "#{bin}/hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end