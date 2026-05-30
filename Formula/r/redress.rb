class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.68.tar.gz"
  sha256 "653fd4d2cebea40a9324464338899ff62b6cb88adfa2ba70a04d61ccc6aef514"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df3fa28b21f9f8aa1ac309e7aff025779aba1a3c818aa3734c94da69833e2de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb90e3aa96141cdcc1cacdafc7e619989970accbedeab79a5d7c43a81aaedcba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb484529570f963707ce4bf0a58ebf42156932cfe447884a4d3cc984c789cb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "49971b91675d64c3030ff0331c676fa5e3a4e5271847e414ba73b96256773102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67432c473e9a5f753c9d8fb1de54811bb9aba5297b354328fa3371afa16d53e2"
    sha256 cellar: :any,                 x86_64_linux:  "7511f96cb33d616641278a5dbc12b2de893ba12defa924a5ac3f251756b53805"
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