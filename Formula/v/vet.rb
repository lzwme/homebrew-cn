class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.9.3.tar.gz"
  sha256 "39f091f7b1438b3405511d9388b02efdfb9c8bd4b35c43923263bcca283f2f1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1411aad71a9a34c3e0b321cb26e4fddd59a21afc8b09e0cef91a4db30a352c22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9f4305bc1d4a414b1bf6279b2af87c8fc8be2137631d6b50245989de80c249e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c327010f68da4ccfc8a86f8831ead0219d013e5967647acbc3d06737477f17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e15b339df67f9a82ed0d87490e25509f4bc0e5c2159693c1bc3be63f254bfa3"
    sha256 cellar: :any_skip_relocation, ventura:       "570169325af1b03a058a6d0c935e97fb86d03a1341a42b1626719acfd995a42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b227d7e00a6bb650ed3427f84797a97189526cf23d3028df72b829a5f53a8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end