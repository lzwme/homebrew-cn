class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8b91d06e26e5a7b3864b724295162f27d6c92a321aeeb81666fc3e14427b23a0"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0944270bc9616872715722ace9fa2f03ca192fd2916433f9081b9ec8542eb62e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f466f0e8b518f887baa52fdfa31c9058b565dafd1de962b97a2b235a424f545e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5520b4a175f0cf5a8f2508b335994fb4a8205322859740fe57803b2b262412c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "431205d44cedc547639cd3d6fa403517af168f97b84d4e105c1ef49b7e96c17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83dc78edc217431bf3f6d51fc2a9079641be4c9f7c0d3104738dc94b1c410194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6f8c290ecb62ed6ff679e17c592ac393588be2989461e81eaf1e75b0433fc5"
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