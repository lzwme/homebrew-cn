class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://ghproxy.com/https://github.com/getoutreach/stencil/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "cddede3013e7f363718bf09eac93f66dbc0cb0cf63a1f2c99915eabff4d80b1d"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db4ae7d01ac744c5d340b82cc3a3eda0e69aa6da210a7bbf43cb21aa89026db0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2254f019b107198c15d0ef4dc186db869849d1150fa4692d37e97d8ad4123313"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10aba0757a0dfa15a8dedac47ef124aaa76a2f5562bea91e16d72644f0644131"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f461d7626d23279a8ab16536d8e283939f3b33d670f8a6a75df702dd0552fad"
    sha256 cellar: :any_skip_relocation, ventura:        "db1ee6d4551a6cec31b9a6fcd711045d8322ae4dbb9418647043746e631710c0"
    sha256 cellar: :any_skip_relocation, monterey:       "769e7046b79a89a1cb27dc7b5cdf59f5826bbe7db65a0843e95039295eef0877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d129ec1cef3c59f9f41923ef377005ba67ae19b7a715be784b0ab56f5fd6b5"
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