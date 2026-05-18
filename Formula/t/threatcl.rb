class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "3ac811106b2f9430c36a61de96b8917d55a4f3607529de0f2e1f19dcbd70a888"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ecc201f2ec3e04a31c5845b747f3bb02684697ee7629eedb3275d9ec0a3141f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ecc201f2ec3e04a31c5845b747f3bb02684697ee7629eedb3275d9ec0a3141f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ecc201f2ec3e04a31c5845b747f3bb02684697ee7629eedb3275d9ec0a3141f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85a5defcac1562a4c1d0978333fa0c16dcf7a5326e6f2480df6d79c5e17fb95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0add57713f335ed2e6f53ccfcb9308682277d756ce5e81b9b44c92705b6d7a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a6ce5b8da008d5ff6f105df9469d82083a9ce88e71bf5c76a5cda5face0f38"
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