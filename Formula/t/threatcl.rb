class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "dfec82cafa84a652c4a0a991f2a1874bcb9918d08ffa80b4f937e1185b24345b"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4fa8048cd262c172de21f2c91f9b48ab238b55e43a9fba957226e8dfaf12228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fa8048cd262c172de21f2c91f9b48ab238b55e43a9fba957226e8dfaf12228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4fa8048cd262c172de21f2c91f9b48ab238b55e43a9fba957226e8dfaf12228"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd5e43f039fb91c959e3a94763efb396ff9a8e1682e10c6636fb42b981d81612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4238fc083f6dfa43555de5bae2dec42b52f1446331f9221522e8a387d1de9742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e603c57e519ebe579593f09f5719e79f4cd1525980ff91e91f19b1e5cc486f89"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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