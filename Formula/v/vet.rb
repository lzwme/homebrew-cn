class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "6c0889bfb5505192151193b7866133ea2c9a78285e65b2a357ed03bdcaabf807"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7911bcea1987d500690718aa448ea069ba3f8e050023645883409c7c00031a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ece6217d249ef074d2cebea7b8771aa313b3d012fb7328032678b94062fec75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "744d0479aee6e3b6eaa83d8bf42a0ee5e4dce8e00c7c575688f32c401e68e293"
    sha256 cellar: :any_skip_relocation, sonoma:        "6807d5f89c34cc19fba2966dae78955887f9a929accf02bb3e0ca5f3c01b0961"
    sha256 cellar: :any_skip_relocation, ventura:       "f00e858b7e3d71d8ac9bd27835897f6f00e9ddb63ecf7279b2b1cc04006bff19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3da6aa6458e8f2c77c9a35106b710dd8cd54c5d2b4383ee410f279b994b516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79ae68c1ba835ce922f83837448beb825e7ac4e173f45e34a4e4cf94d92f913"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end