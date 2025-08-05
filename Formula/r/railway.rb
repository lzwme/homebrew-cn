class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "b8bc7eaf20dd45504ca2052e4a8cbeef8ea101b379b2d5e24d6683157d476e13"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82a517878a1c6c2fd38195e9afc9b9f17e17dc70f9eaed8ce96679e9bb998ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9d0baa057e265ed1314bcf8f84318cb1c58c87a5c3dc5761d8ad173818f4b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f626972ea0e9afc59258b7afdbce75bc0e47821ec354665b9141d50012f776b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e058f4212e5c8180232c878901f1c2b43b052fc8232bc5421c91c2b4b784c32"
    sha256 cellar: :any_skip_relocation, ventura:       "855940dfd33288587fd5e646f9ec851e2513505119e5a3fcaf4fd89f6ddb4d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450d881cf0777ead5e4d65801c9204e70d73aa189e7357c493f68273f41f0fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c4a990557a24c792b0741c11947294015c16c32e9cd2a590e75cf76d75b9d8"
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