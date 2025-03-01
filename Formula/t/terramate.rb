class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocs"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.12.1.tar.gz"
  sha256 "dc5f3ba4e262fc32add1affb64e320cefa0695d3d183d8ef7dae60e78542abf9"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f74d528fb3bbd824a478b425cfd6e48a69b84a1b20fdf1d86f612ebaed0db14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f74d528fb3bbd824a478b425cfd6e48a69b84a1b20fdf1d86f612ebaed0db14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f74d528fb3bbd824a478b425cfd6e48a69b84a1b20fdf1d86f612ebaed0db14"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82ec51f0db2fa413b010b0420163b26948a4d8053a06724fb459a9c2c051edd"
    sha256 cellar: :any_skip_relocation, ventura:       "d82ec51f0db2fa413b010b0420163b26948a4d8053a06724fb459a9c2c051edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144b8ea2a2a78f84307f91ee60a953dd466ba5c8518e2411dfe4b0fe04830aa5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end