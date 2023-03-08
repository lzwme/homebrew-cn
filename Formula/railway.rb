class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "42dd87deb73bf07de5fce0ecd250980d47275807fe7cf7a453d532d468d9e9ed"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f6a9c65531d45f09e40ae8e941e82f4fb739849fc06236f0a8fc6609030c9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "878c3741cedc121e569d69841daa4c392a230f981505b4546543a3f2b9a22a08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6061442b365e6f549b1b1c21994144164d99bc56ea751655e1c4ba9e2089fb52"
    sha256 cellar: :any_skip_relocation, ventura:        "794283c0625da00de60cdfde44aa5c533face717e275f0919395ce18d35052e9"
    sha256 cellar: :any_skip_relocation, monterey:       "f24e8f5267e2cb354cbab9fa0254d76d9289f6d924514df5d796f781deaba1ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac17bc79c54de9bd82c881931a595fe4f4b45507d936edb8831d26273cf175aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81236a8367807b61963d2cc7692d5874086f312b77b477001ea535b0781e9154"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end