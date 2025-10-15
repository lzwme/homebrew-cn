class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "b0cfd7bc212f29e1af190e6595912378926fd64befdc26e04b4739270c668601"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "913e3bb7456c04dcbbadcbc54e8ba407dd1f8db772fe144401872df66b7241b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdbf60d8445b7f5067148a824ca1f70a4e138d87d872bafb48ccab7c4dadec08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0bc55fcfeb23137d9e707c03e3154df54a9b2ccf9255b01ca85f211a496d8bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e361d834120621ae309afd3e327b271171a29a8cb7d4f54f26a9fed46b9db55e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7753153529db7a90229f85b9c753d2189456aa7f916e7409afe8dae577ac951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfae3b835a89033df0b5cfd9da2da82638403c8089690cf49c6aa84d0f083a09"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end