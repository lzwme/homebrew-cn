class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.44.tar.gz"
  sha256 "26c60c539136e2f2a72ac1f28000e7139a8aa1536484b887fa2f7d1fb3a5de2b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f80c59da129fbf375706ae12f0d65ed80b3401bd424cc8325d2ceacc7c3788a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bfa3f06c627240bde3361d0ddfe9eb5afa9bed49207600e71c378fab1035f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca5439892fb8b3c8d171c589064a28ebd5cecc2c17abb48b851fa12b504c9d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4192215a1ff09343179587184e48062d6e8a7be0e32c58c08cedf10fed9edb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "566dfb9a8b88d06d3b45d1147ec689c182b57cd215a2ee83e779c7e2a4b562f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "631e26919fdd7fe07def25a2e1d267d732dbadb8039e6c797eee6805628559a5"
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

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end