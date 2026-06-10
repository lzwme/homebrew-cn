class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://ghfast.top/https://github.com/cabinpkg/cabin/archive/refs/tags/0.15.0.tar.gz"
  sha256 "9f8b4904c1d4072cddb3f8316cde694cb55791bfb817b1f5818f49f1d156ded6"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1664bc30a768217f8269c7d189c8f0af40ca7851395fccccc8c1717895fd72ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d1ba1ee13ab381fe5349764021e8a8032b272cbfdd3f984136dcdc1f281942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aedcddfa6220cf7fb396f6b99886d738b9846e59f4ecbf8ac4e87f5539d02f0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "791e503cef7636fd27f298981bcf5096f07b8f530c9309b5f0681d30085f57d5"
    sha256 cellar: :any,                 arm64_linux:   "0b11a49be73372686c53b1f36032d17dd53f4df1f72daca1a9b169b1c597a7fd"
    sha256 cellar: :any,                 x86_64_linux:  "d8d2aaa79e8b6d44c821c14978782359ef7d0e4bccd7ee0acb7557db41bcbae3"
  end

  depends_on "rust" => :build
  depends_on "ninja" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cabin")
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello from Cabin", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end