class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghproxy.com/https://github.com/TomWright/dasel/archive/v2.4.1.tar.gz"
  sha256 "eb44263c792ff3b31e5a5086d01b471d07a4282af6716932f12f76bb8cd4eebd"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbaeea8b0af2c8b272a5dbb5a7a869de672ec70199729e3fcdd4774dbdb1fe5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c9e2dc4eb17301b311773cd3261a856d5bbe9a708198fedf2ce617dbd97871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b2f01e5fdd715ae4cfc6051b9139b2a4add0ed36c959033631d8abc40ec2c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b25c6a182ec2c505b6520601f0661c292764e5e0e064472efd1b1e72015b857"
    sha256 cellar: :any_skip_relocation, ventura:        "d348e92a3a918fd802b2ba57cd9dc5587aa671702df51ea7c0867634e58e76a7"
    sha256 cellar: :any_skip_relocation, monterey:       "d67d18e45d6da907f84ded47a2e0eee5c5bcdac0b5e86a76b98f1fd7086f96b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a43752665ca8310a8a981a10224db12ecb815f69c7228af8eda36e3ec881215"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end