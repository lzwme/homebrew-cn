class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https:stencil.rgst.io"
  url "https:github.comrgst-iostencilarchiverefstagsv2.5.4.tar.gz"
  sha256 "de0e3c817aa3591c8cb69dbf053249d49278086a28cde56d3dce478c74f15a64"
  license "Apache-2.0"
  head "https:github.comrgst-iostencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "287c158d5a3026588e2059c8aa4f8f5ceaa77903ab97de4b0f38c028bef729f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8f71959ae4b88bb9fdb25b1b12e978318e58c7b076bb5367c83f1b2925108a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7672ebea0fdeb2fe7e67deee0700f3af8c108ce8f34b77639b41ceb0a88d376f"
    sha256 cellar: :any_skip_relocation, sonoma:        "63cea30335820f1973e78bf0458333562369d8bd0c8a0695d6e2971db53a31b4"
    sha256 cellar: :any_skip_relocation, ventura:       "ae7b259b10a40e46e9071087b63539a63eebe33f4c4395844c72e28ebb65912f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb63658ffbcb8855eaed5618c9f42be3be9911c8466133cfd3e08adbe7915a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc61a5d15547bcca11c1c57e512dfbe47a4086538a67fb6e51477406649cb77"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.iostencilv2internalversion.version=#{version}
      -X go.rgst.iostencilv2internalversion.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdstencil"
  end

  test do
    (testpath"service.yaml").write "name: test"
    system bin"stencil"
    assert_path_exists testpath"stencil.lock"
  end
end