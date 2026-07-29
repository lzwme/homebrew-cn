class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.30.1.tar.gz"
  sha256 "be8d5806f1188a3abc39e91176431f5e712749d6f5d2c82aeb4ff290ed634057"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2324471834323e28dffdac8b6fa6fd6f2a084d2c0b05172f0eafad2c601f2a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8a4bc1027731639327e78bf14bc68b140e54be55c53e4312bd3e0958761587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4192bd04e8443a2bcd6a79de70f145a035b9e191f9078905b18915d0b3f2669"
    sha256 cellar: :any_skip_relocation, sonoma:        "960f38e68bf06bb85cb82be7f5528fe98b71d1abd31eaf6644ebc12c62575344"
    sha256 cellar: :any,                 arm64_linux:   "1c3cd86d77c27949169d1ca149b138e8304ca3068d1ad5f8fbc0e4a7205b5d8a"
    sha256 cellar: :any,                 x86_64_linux:  "46093234d0fbb5872efb75a3d634cee12276c2334a1aa99adac8222adfd6b481"
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