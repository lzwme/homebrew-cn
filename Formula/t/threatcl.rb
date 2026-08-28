class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "3f1849155f42e80f6a7c3271e20d2e5b47c369e6e5a65fbc0d54679fcd55bc84"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c17104a8dda4e0bd957970302b87dd2dbf17988aefdaf73c09ac2ace830fb56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c17104a8dda4e0bd957970302b87dd2dbf17988aefdaf73c09ac2ace830fb56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c17104a8dda4e0bd957970302b87dd2dbf17988aefdaf73c09ac2ace830fb56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5312288f51f94c760c95664ccae45a46ffcabdff150f118d9e46ccca93062085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345d325f47733dd625ba18044e23d0e2f448762d3f853aacc0f779f0281df0d3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    # Other examples remote-import files that need `allow_remote_imports`
    cp pkgshare/"examples/tm1.hcl", testpath

    assert_match "Tower of London", shell_output("#{bin}/threatcl list #{testpath}/tm1.hcl")
    assert_match "Validated 2 threatmodels", shell_output("#{bin}/threatcl validate #{testpath}/tm1.hcl")
    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end