class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "68f1fe99dc19fd34e7b35619ecc8d007cd61eae706e16b2ab73e3568a53471cf"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "265bb1b1198729419e36550c6323e7e6c28eba9909b8175b54ef074abf3bf4bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae16b6ba5e3996db3aff8b034fec202a649aeff7808edf79fc3b82b0238895b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc09150efe239e1bf4baee9d6e5a9009aa1449ae465d3fe690470d9824349c3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "006259bf4a9a572be6f9500e3ef89230498b0f5e5c88a94f5050bcf073c37925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e20f961ac2d3c694eca08879f5963789dec8e89c98e669264645daffab559427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5917bedd28ce2d8dca6f7f160011c6c576d55f0ee3478fd791973fa50d12e46f"
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