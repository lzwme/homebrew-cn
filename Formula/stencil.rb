class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://ghproxy.com/https://github.com/getoutreach/stencil/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "45ec2921d4ead2073f6370ba489ae30bca7cd0e2b90fe4a0a3a3ebc1808e8fc0"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b059944833156fd58f996ee46bb0486f7e6d3f37dd038af1269f6480d32a9212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4461699fff1f44b1ab58a7b9c2d65c0476b93d34259fd0546c24f70d5df1591d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bc68c52342135f15624cd49263a230a667e3cab0d31ff81f32bf2bf17997b0f"
    sha256 cellar: :any_skip_relocation, ventura:        "fbcffc84288f0b10bf2c2c7b10965d23ee9cf37057087f9f33f983decee3a90a"
    sha256 cellar: :any_skip_relocation, monterey:       "296316b6332e1808cc8e67aa2f7e760b1756c0759dda68a3130ee6de889cf4c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "70caa16b5410faede43e56b323e1ccda18e7be8c882436e33f14ab55a6c9db0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422748968d967a56f9f2bcf5e6f13fbe8ec4e532be87f3ce706772315147eb1a"
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