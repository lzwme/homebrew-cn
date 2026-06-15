class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d93336722b62d01598d28ad1ef707508925953315cb542eef64935d6093f769d"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9be2261b7047e68c4d54d8d9dcb876bffc066a4dd64fe0ae03b6f4efcaee6fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9be2261b7047e68c4d54d8d9dcb876bffc066a4dd64fe0ae03b6f4efcaee6fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9be2261b7047e68c4d54d8d9dcb876bffc066a4dd64fe0ae03b6f4efcaee6fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "697f37e94920e11ec2994d8e5745e6a1841c02e59da7bdb26187640015a1af89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b04387531a6c759690bc9d167cd0ab564a233a0f30f9be4edaf009b1c0bbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdf9f9ce9ac005cac681bce56b0128ac9aa491b3d4415703ab0d1200df1bc86e"
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