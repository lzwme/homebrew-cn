class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "abfc302309def0a27d4934f58791a587c3e82da7ab0c09449c03f546bec41e38"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "711593e56a970548e355a54e76c1d9d1ef2fec27cb5a5f5a51feb3832541497c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865873248fcce2a8ae839266a1c1feb5be89c16605394a5cc481566290060a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a40698e6a8b5544e4659a8bd193f58ee46eb9d86230fb81ce02f827f40aa9a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7b225b8fac06fd099f91e31e6d9b3260d5dd797492b7aeb403b03aa98e8242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6708acfa99ac5f68a1e1eb56c9d1442a5fb18952abe8485c350e1ac0b67aad17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4ed71f1e1faad027b448b7a4e058c0d89cf3a134cae357596724ea4fdff650"
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