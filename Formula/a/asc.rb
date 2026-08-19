class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.5.0.tar.gz"
  sha256 "3d2dbe59110623e7201df4afa1818cb98e7c1e3fd30318f97626dc9057128ddb"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35b43458475a59efa0e856b799a150c06eeaab868026fd490c69fc79805f01a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67751272ed1f8b944cda8eb5d04f58db02f797594371e7f020a32a8d93b4bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcce569e625a25eea67ddf4961b2382a454317627fa708dfabb5f39026ed763f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9064447db0cb13d85152c6f1c5abefcf8e6945acd63b7a9250cb00c5aca93c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "895eb18f0f79b727f1b896dc568de0772137a36223e3ecc4d9d5650e273c24e8"
    sha256 cellar: :any,                 x86_64_linux:  "679e2944cb2a03ce3be766b3b7f8211115b9c8c6cb90cf257beea771c843815f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end