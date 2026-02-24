class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://ghfast.top/https://github.com/Kampfkarren/selene/archive/refs/tags/0.30.0.tar.gz"
  sha256 "2cb62ef165012f062208fbc906af0f390a60f2adcf0cba9f1d60c12feccf8d23"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335e48a736314eeb33836273c91e26734509abd4b5d246ef552a4961dc6ab7b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af72430d846eff1f783096666508708b76a1537d43005bf5f36673999d3919a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb85979512627975c42d1049281d6ce78547151b3a8aa7e7b78ce129694e367"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d67cbb0a229ccb041d4965c87af5c059c711d89071687ace7fea0ebfabd5c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a36f5ac7dfc7a63d8097091531ace07145ce085a34679aa4d60a98642b1393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "507d2ffbdba0be10049b46bfa6fd26be6c11b28eb72f940e7290debb40a50fd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "selene")
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end