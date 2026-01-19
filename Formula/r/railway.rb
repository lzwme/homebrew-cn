class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.25.3.tar.gz"
  sha256 "01301ba395cf3c084c2574bd900d950a667ea6ba1e93ffe95844efb38c72c819"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b6da83cec4eae21087cb0747be6a0fe62d0c6b6d529d8269a30983416dda970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d613d2ea0c5563dc91fb47957e5a772f18ffe3f42728e215d39783d466d2817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc12e7c98fe9f025b701a90e08f8aecf6e2beac250a9ac71e5a166a3cd920b1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b451dbd392b47e6b36a1a63717a88445303fa3185536460d8b1580a31c082bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c1362c32ba463e7504decdbc73ece42ebff91e78f0489c49e01c923a1d01b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4be6bd2df1ce0339af86cfd537ddb96786637460c13f5503725f24a4c9a1034"
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