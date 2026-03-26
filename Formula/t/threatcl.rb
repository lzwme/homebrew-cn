class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "cb0908acde4e70324b2ba7c50e4bfcbd9ee1b394feba20cb58b808cfcd632ebb"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25669e208bd1eae9a71ac16017c78c0f0a13116dea35c14cefb9490ed6e5e7d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4e18f59220abf554e0e9a56129bc127bccded47a432f966cb79802cb550799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2420661473c7e33c159c865a4827e6f749c9fff53678c273e2e1477a552d051d"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1775c9d01ce8df26081d097fb6a8a7cbe791b11fc1cc068abc91912680862a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aec16c78a3d1c6f3268edc5188d3d832def34668da80244611126bc59a0b650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a7f5aeea3cb3b25358dd32ec66ddc672da8ee013ff6301ba919272ce075434"
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