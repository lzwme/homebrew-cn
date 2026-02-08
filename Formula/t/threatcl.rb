class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8e8f9a4d49c2f3889f7b00f1835d5307c6f5fe5c6e82e8ab85d0033c01646bc7"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c8ef36ca25d54fe6702bf626abcda67562f43d418d935e90f3f53d09c8d3bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e1af7d006afc60621dcf62c461f6d038fb6f2e4b3b4ae4f1b33a17f44c81ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa472cb757e640c5190b2a2b658ac251eac7f9727e41eb0390b2c7d1a106a504"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba191ac51db9a6d73c3bdda52c098e69370ae13b4360e25d0c2a8d73eec19f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0197f670ed86e65d3ab3757177e908f2167ce12eba013c608f5f6f2a76448cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d3e6389452cf3f4c3daac8cefd801cb4ab2b57a453805515205c5f72ff33b7"
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