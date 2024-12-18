class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.20.0.tar.gz"
  sha256 "e43b9c0388ec885b90c9a52a661d3d6e32de2c1c0d4c56d042ac525d798dbdb4"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64085e5c169519fe3345bbf5c15d3ac09736169f959e5d6d3af5127ba3d798f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "569f095e1a08da22f5c6b7ee05598ca0619594a4688a5954b18a2704d5941beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0305a16bde5d5f29d6c6e587cb75ef797bb9d4669dbf3d2a1a0c7e884794eb34"
    sha256 cellar: :any_skip_relocation, sonoma:        "2279582b24c94b3e9e907b552b1caa99c57472f72f302d0a98cefb170a7f7e88"
    sha256 cellar: :any_skip_relocation, ventura:       "4d6b346d4f594345e78142aa824e098bfdf7038a1fb423d7524f3e7e21bf1598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc275e3503346893aec81f242789e9329c450538e0c0adf7888fb424352a913"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end