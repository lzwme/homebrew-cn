class Access < Formula
  desc "Easiest way to request and grant access without leaving your terminal"
  homepage "https://indent.com"
  url "https://github.com/indentapis/access.git",
      tag:      "v0.10.13",
      revision: "b315c75e461e0a0cc0978960a80ba352ea8ff85a"
  license "Apache-2.0"
  head "https://github.com/indentapis/access.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d72d19172c369f06e75b592c6638f321d4037212c1133e92f6a77338c4bb91d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d72d19172c369f06e75b592c6638f321d4037212c1133e92f6a77338c4bb91d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d72d19172c369f06e75b592c6638f321d4037212c1133e92f6a77338c4bb91d8"
    sha256 cellar: :any_skip_relocation, ventura:        "07d21cbdb98e62015a0268c4fc4d95df3c3c08a3b894f28e88709830d815698d"
    sha256 cellar: :any_skip_relocation, monterey:       "07d21cbdb98e62015a0268c4fc4d95df3c3c08a3b894f28e88709830d815698d"
    sha256 cellar: :any_skip_relocation, big_sur:        "07d21cbdb98e62015a0268c4fc4d95df3c3c08a3b894f28e88709830d815698d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a79bf2d2657b530ea0d6a6d2e56f209419ade6d3250ae506db41d000a72d9ca"
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