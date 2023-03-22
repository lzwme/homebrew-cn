class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://ghproxy.com/https://github.com/getoutreach/stencil/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "80921d02d73272956cb65c0dce96afbd06e5c6ff51f9686639a831ec8095f5b3"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcd309cbc4c3520670d631d08b39c11ab179d1071fafc93a4663ac65aa5d3361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21ddaf49eab492f1d59a6351d8a7bfae67fea16e48f1a9970c3ca5221323f916"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28b70638dbe88ce9bda599570e0ff49af1cc111b036e3239fcc2c28ff4b1b8b4"
    sha256 cellar: :any_skip_relocation, ventura:        "d17222d4ab90f4f6556e5779ea25d371b62d3a8b792a4e2037e0532dc0e2fa43"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd42b4a02961c7b20c4ac5a905a675b6700965e352d4509c5d44f4c0225beb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "daec11e5a29c2c5b3209792132a623a25a05d031a9cf008e8e8e1ad9b66ca4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120072bf97828325c8b5ac0b530a0899ecf776e34156e18ffa679585eeb12f53"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end