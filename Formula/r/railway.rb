class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.62.0.tar.gz"
  sha256 "8c02af7d3e16fe842231c043910241ed6aff25a3efc972d7a99839c3a209b939"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdf77a4f62b397c8996d423c1142e4ab4035cad10050a1f5f27a4d642f9e062a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cbe1c97fc3173b54756eeb2df3044639e8c42093132d648de17f5101e7f5aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f33ebfbdb7c56300dc30b760dbcfac5d1607a1ce79bc7b0aebb8b8d57123ff3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "40304d81f2972d2c0a5eedc2126af9fe75a53259ce7ca22604ed6938c0ae7b9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d974ec076e20ecf716efb83bce70d5524f337f3ea64fd66aa2d2ea6d6214c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be48f10043e8a3796189e3b4c1714b53c1e275481fed11dbe9f6116991c19512"
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