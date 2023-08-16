class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://ghproxy.com/https://github.com/mattn/goreman/archive/v0.3.15.tar.gz"
  sha256 "3eb3bd3b80a1d0e0a28e595b6dae524770dc1f9d47bd1a1664b291ba6a08ff6b"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d09c2e7420bc60906706323a49d65afa612cb477ddbb0c1edd9f5e1721f7ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d09c2e7420bc60906706323a49d65afa612cb477ddbb0c1edd9f5e1721f7ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43d09c2e7420bc60906706323a49d65afa612cb477ddbb0c1edd9f5e1721f7ad"
    sha256 cellar: :any_skip_relocation, ventura:        "5771bfcd34c5bf8a1327f0a29b44908e21b4b251caa0c8c324ae2924302cbce0"
    sha256 cellar: :any_skip_relocation, monterey:       "5771bfcd34c5bf8a1327f0a29b44908e21b4b251caa0c8c324ae2924302cbce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5771bfcd34c5bf8a1327f0a29b44908e21b4b251caa0c8c324ae2924302cbce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f12a9760b379dd8e4cf4c39a69862b5a0fadfec40e511e71408006c5943c8b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end