class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.30.4.tar.gz"
  sha256 "18b14625c98cc90315a2d6416f8a3961f2df0b570fc2fae25f69c8b8db54130d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b20ace62830dafcbf9b648010f5a16ebe2dcc602d3e5a20978eeb0cb0779ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca0747af92efb4ad84cedb9cec8748438c21fec8cba8de546b3034521baf87c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052046c54540c7a005e2938bb163334d1ab7fb3fddb11682188e35ecea1701d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "344e3b65607e8666b94d64f74325fa314419e17e784c8a9ba5cf65434d92af05"
    sha256 cellar: :any,                 arm64_linux:   "0e53b013dde89b7ec67bb2e8a6788b2e0d8a4671d11b74752547427b01f210b3"
    sha256 cellar: :any,                 x86_64_linux:  "127dc29fea3929a5d20ccea9e214b5f40800bbe3f84628e90c0b20ec427a9240"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end