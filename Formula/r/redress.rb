class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.58.tar.gz"
  sha256 "46312dc76f265acad44b78247dbb86e2d35821c65310723bca6eb536e79869d9"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "617cc308b56695ebfa74635932bcf1fbbd6d798d53826b4d0de1949ad560faf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc4787e4fef8969f5c32b547390530fbc17d0fcfb7db28f94abebbf8d873094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08bafa43fce9b21521991c12b5ca61abe0c105647e857b4806c9dc5e9300e4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe2e21d39a3084d429e2a5711c47129fe635eecf31b4af0e27a7e18a541c2c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a79b889f3bec8b6ce5152cbd0e2c403a5d6742b196c37a7f4c97097ae19ed9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3099353c25c016ff3f2a42788d99f5453f8ec1e51ba626198fdef262150c46"
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