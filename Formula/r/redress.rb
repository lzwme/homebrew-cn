class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.54.tar.gz"
  sha256 "b86547b5bd050d039eb112202e3ac47005d26b4f59eb299233d24aade1950c4b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e26166943146d6944b4f01ff0af2cd0c2716980dce221f00be27e77da33831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "039012ca1d7ad36bca4b372152c6964d6744ec737937cf0c5d3221a6ac0e2bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4077891ef2ae17be3cd9b27c16e74bcae651cf2e381633f58eb748facc2a101"
    sha256 cellar: :any_skip_relocation, sonoma:        "57897a8af5e6b319d1f2864363c5faecb618882f75915945742bef3f6722f0c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b32363dde775eb6826f65a0920fede813a0ee6aea4d44374de316bff8e48c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8363aefcf3915d5c6ba6af89d7038487f8134c4719c02a9d9e47459f0ca4353"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end