class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.179.tar.gz"
  sha256 "6ec1f54b170c0d8ba1d1e9c54fcfeb152c06d23e98055fe74418c7e4ea44bc9f"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3a9e66702ad365b362579342c7270cc60ce591303f7b01ecc0483e56474548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3a9e66702ad365b362579342c7270cc60ce591303f7b01ecc0483e56474548"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa3a9e66702ad365b362579342c7270cc60ce591303f7b01ecc0483e56474548"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f56bf22b9bba12aed5694cc266132e5cb5730be313bb284f2e879066c5a3434"
    sha256 cellar: :any_skip_relocation, ventura:       "7f56bf22b9bba12aed5694cc266132e5cb5730be313bb284f2e879066c5a3434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8d38e4c55300f32b429e022e62055ba2f692b0632571e37ba2954d764a7044"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end