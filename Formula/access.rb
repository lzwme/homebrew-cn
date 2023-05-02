class Access < Formula
  desc "Easiest way to request and grant access without leaving your terminal"
  homepage "https://indent.com"
  url "https://github.com/indentapis/access.git",
      tag:      "v0.10.9",
      revision: "19955980a9fb76ef294ea19829e0479c37e81898"
  license "Apache-2.0"
  head "https://github.com/indentapis/access.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a51449899ec8fd96c9ff3091a9adfaf6c9d59534d5e53f1e35ee8faf0c5caa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a51449899ec8fd96c9ff3091a9adfaf6c9d59534d5e53f1e35ee8faf0c5caa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a51449899ec8fd96c9ff3091a9adfaf6c9d59534d5e53f1e35ee8faf0c5caa2"
    sha256 cellar: :any_skip_relocation, ventura:        "6ac545fdb6d6298f0fdbabd89f84b74b449526287ff866545c8f9565af842f74"
    sha256 cellar: :any_skip_relocation, monterey:       "6ac545fdb6d6298f0fdbabd89f84b74b449526287ff866545c8f9565af842f74"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ac545fdb6d6298f0fdbabd89f84b74b449526287ff866545c8f9565af842f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4617c7c101c3172512c99356b253bb3aa5c46fa4dcaa5f96b404c3e18be8d2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.GitVersion=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/access"

    # Install shell completions
    generate_completions_from_executable(bin/"access", "completion")
  end

  test do
    test_file = testpath/"access.yaml"
    touch test_file
    system bin/"access", "config", "set", "space", "some-space"
    assert_equal "space: some-space", test_file.read.strip
  end
end